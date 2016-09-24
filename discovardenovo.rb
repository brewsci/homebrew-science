class Discovardenovo < Formula
  desc "Large genome assembler"
  homepage "http://www.broadinstitute.org/software/discovar/blog/"
  url "ftp://ftp.broadinstitute.org/pub/crd/DiscovarDeNovo/latest_source_code/discovardenovo-52488.tar.gz"
  sha256 "445445a3b75e17e276a6119434f13784a5a661a9c7277f5e10f3b6b3b8ac5771"
  # tag "bioinformatics"

  needs :cxx11
  needs :openmp

  fails_with :gcc => "5" do
    cause "error: reference to 'align' is ambiguous. See https://groups.google.com/a/broadinstitute.org/forum/?hl=en&fromgroups=#!topic/discovar-user-forum/zuqNcaRUetA"
  end

  conflicts_with "allpaths-lg", :because => "Both install bin/MakeLookupTable"

  depends_on "jemalloc"

  def install
    odie "DISCOVAR fails to build on Mac OS. See https://groups.google.com/a/broadinstitute.org/forum/?hl=en&fromgroups=#!topic/discovar-user-forum/zuqNcaRUetA" if OS.mac?

    # Fix for GCC 5 error: redeclaration of 'template<class TAG> void
    # Contains(const vec<T>&, kmer_id_t, vec<long int>&, bool, int)' may not
    # have default arguments [-fpermissive]
    ENV.append_to_cflags "-fpermissive"

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "DiscovarDeNovo", "--version"
  end
end

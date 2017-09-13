class Discovar < Formula
  desc "Genome variant caller using Illumina reads"
  homepage "https://www.broadinstitute.org/software/discovar/blog/"
  url "ftp://ftp.broadinstitute.org/pub/crd/Discovar/latest_source_code/discovar-52488.tar.gz"
  sha256 "c46e8f5727b3c8116d715c02e20a83e6261c762e8964d00709abfb322a501d4e"
  # doi "10.1038/ng.3121"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a1224626458f35381238ce9f55c2105749dadfb6098d467e2601e2ec21feaff" => :x86_64_linux
  end

  needs :cxx11
  needs :openmp

  fails_with :gcc => "5" do
    cause "error: reference to 'align' is ambiguous. See https://groups.google.com/a/broadinstitute.org/forum/?hl=en&fromgroups=#!topic/discovar-user-forum/zuqNcaRUetA"
  end

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
    system "#{bin}/Discovar", "--version"
  end
end

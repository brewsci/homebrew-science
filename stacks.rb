require 'formula'

class Stacks < Formula
  homepage 'http://creskolab.uoregon.edu/stacks/'
  url 'http://creskolab.uoregon.edu/stacks/source/stacks-1.20.tar.gz'
  sha1 'fad38ceb3eb8ab4d240385c769b45be52fb6ee2b'
  #doi '10.1111/mec.12354'

  depends_on "google-sparsehash" => :recommended
  depends_on "samtools"          => :recommended

  needs :cxx11

  fails_with :clang do
    build 503
    cause "error: comparison between pointer and integer ('const char *' and 'int')"
  end

  def install
    # OpenMP doesn't yet work on OS X with Apple-provided compilers.
    args = ["--disable-dependency-tracking", "--disable-openmp", "--prefix=#{prefix}"]
    args << "--enable-sparsehash" if build.with? "google-sparsehash"

    if build.with? "samtools"
      samtools = Formula["samtools"].opt_prefix
      args += ["--enable-bam",
        "--with-bam-include-path=#{samtools}/include/bam",
        "--with-bam-lib-path=#{samtools}/lib"]
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      For instructions on setting up the web interface:
          #{prefix}/README

      The PHP and MySQL scripts have been installed to:
          #{share}
    EOS
  end

  test do
    system "#{bin}/ustacks", "--version"
  end
end

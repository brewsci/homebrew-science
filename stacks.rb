require 'formula'

class Stacks < Formula
  homepage 'http://creskolab.uoregon.edu/stacks/'
  url 'http://creskolab.uoregon.edu/stacks/source/stacks-1.12.tar.gz'
  sha1 'eb2c176c5605297dd795ae6f1ead81ba566a3688'

  depends_on "google-sparsehash" => :recommended
  depends_on "samtools"          => :recommended

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

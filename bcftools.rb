class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.3/bcftools-1.3.tar.bz2"
  sha256 "fc5332e49546d55120551b0d5fb690f79e4f2216b8492c7b53033cdaa4256a3d"
  head "https://github.com/samtools/bcftools.git"

  bottle do
    sha256 "7abcf9981eefd124b830f6e20615e63c94d618f8d63a2cfe7d432963abce8081" => :el_capitan
    sha256 "eebbc40d36b3a3dda96396dcdddaa50ac52675252ae8bce8c5d0ff031db59e33" => :yosemite
    sha256 "0b1800347a3219efad6955347fd3652bac5769c32b0b4dfbf16c9577d262d5b5" => :mavericks
  end

  option "with-polysomy", "Enable polysomy command. Makes licence GPL3 not MIT/Expat."

  depends_on "gsl" if build.with? "polysomy"
  depends_on "htslib"
  depends_on "samtools" => :recommended

  def install
    inreplace "Makefile", "include $(HTSDIR)/htslib.mk", ""
    htslib = Formula["htslib"].opt_prefix
    args = %W[make all install prefix=#{prefix} HTSDIR=#{htslib}/include HTSLIB=#{htslib}/lib/libhts.a]

    if build.with? "polysomy"
      args << "USE_GPL=1"
      gsl = Formula["gsl"].opt_prefix
      inreplace "Makefile", "-DUSE_GPL", "-DUSE_GPL -I#{gsl}/include -L#{gsl}/lib"
      inreplace "Makefile", "-lcblas", "-lgslcblas"
    end

    system *args

    pkgshare.install "test"
  end

  test do
    assert_match "number of SNPs:\t3", shell_output("bcftools stats #{share}/bcftools/test/query.vcf")
  end
end

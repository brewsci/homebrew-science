class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.3/bcftools-1.3.tar.bz2"
  sha256 "fc5332e49546d55120551b0d5fb690f79e4f2216b8492c7b53033cdaa4256a3d"
  head "https://github.com/samtools/bcftools.git"

  bottle do
    cellar :any
    revision 1
    sha256 "e5722e46e71e0af5719fee3949b76a56cb75d94318ffc1aa68ce0d758cddcd32" => :yosemite
    sha256 "4b5c238d91a078c98637fec874644fbe352d14f01f83c3a8de4c6627301ced4a" => :mavericks
    sha256 "4395d3e784632d25f34dfb431ebae11457206dddef3a580f87ed75c6500b594d" => :mountain_lion
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

class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/archive/1.2.tar.gz"
  sha256 "90ccd7dccfb0b2848b71f32fff073c420260e857b7feeb89c1fb4bfaba49bfba"
  head "https://github.com/samtools/bcftools.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
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
    args = %W[make install prefix=#{prefix} HTSDIR=#{htslib}/include HTSLIB=#{htslib}/lib/libhts.a]

    if build.with? "polysomy"
      args << "USE_GPL=1"
      gsl = Formula["gsl"].opt_prefix
      inreplace "Makefile", "-DUSE_GPL", "-DUSE_GPL -I#{gsl}/include -L#{gsl}/lib"
      inreplace "Makefile", "-lcblas", "-lgslcblas"
    end

    system *args

    (share/"bcftools").install "test"
  end

  test do
    assert_match "number of SNPs:\t3", shell_output("bcftools stats #{share}/bcftools/test/query.vcf")
  end
end

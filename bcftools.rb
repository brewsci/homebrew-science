class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/archive/1.2.tar.gz"
  sha256 "90ccd7dccfb0b2848b71f32fff073c420260e857b7feeb89c1fb4bfaba49bfba"
  head "https://github.com/samtools/bcftools.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8cfb381d2fb4521a3750084a6c67790a0b248ffa" => :yosemite
    sha1 "3a216df0a0f34ab4187d082523b3c0bfef11eace" => :mavericks
    sha1 "628e8bd74cd72548fb3907cb75e1e9bd65e512c3" => :mountain_lion
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

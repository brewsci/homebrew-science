class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.3.1/bcftools-1.3.1.tar.bz2"
  sha256 "12c37a4054cbf1980223e2b3a80a7fdb3fd850324a4ba6832e38fdba91f1b924"
  head "https://github.com/samtools/bcftools.git"

  bottle do
    sha256 "aa497ce3f323c1d84ab6f9fd52bad51764ac647503c31c2cd031aef3b3d6c98e" => :el_capitan
    sha256 "2bbbe29afa371c40aaee36cc332eae394cca899ca02d34acdbae1e5adf047773" => :yosemite
    sha256 "3e3bc6bec1399dd5c5baf0a4486dde24c1f8f4aad1b273232b2745b1784bd03d" => :mavericks
    sha256 "538d88065ed818fb4e9d997e7e7bb41b4bd6a5559600fbffe4585dd6bcf5879c" => :x86_64_linux
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
    assert_match "number of SNPs:\t3", shell_output("bcftools stats #{pkgshare}/test/query.vcf")
  end
end

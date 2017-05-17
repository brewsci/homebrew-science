class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.4.1/bcftools-1.4.1.tar.bz2"
  sha256 "d7d0871846005c653f5e2e78e434f7f9b846ab245ab5c1cd4224ecbf52d99d08"

  bottle do
    sha256 "141a227a417c9b0fbf77757aa88f66cf90cc8ed3b6f2bc74e144a79fab7ca91b" => :sierra
    sha256 "ebb0b0c0b1054176fe2f10473add3c8076ae777f26f2a6b81089dca4d21f1afc" => :el_capitan
    sha256 "679e25baca499bde02c11ed993a9eca1b7738f3f21804e9f817c63ddb06d3386" => :yosemite
    sha256 "bfa3c9e18c5915b2af83a9b16c2277b6bfa2229ae37183dbd14e60ca61729ffe" => :x86_64_linux
  end

  option "with-gsl", "Enable polysomy command. Makes licence GPL3 not MIT/Expat."

  deprecated_option "with-polysomy" => "with-gsl"

  depends_on "xz"
  depends_on "samtools" => :recommended
  depends_on "gsl" => :optional
  depends_on "bzip2" unless OS.mac?

  def install
    args = build.with?("gsl") ? "USE_GPL=1" : []
    system "make", "all", "install", "prefix=#{prefix}", *args
    pkgshare.install "test"
  end

  test do
    output = shell_output("#{bin}/bcftools stats #{pkgshare}/test/query.vcf")
    assert_match "number of SNPs:\t3", output
  end
end

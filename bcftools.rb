class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.4/bcftools-1.4.tar.bz2"
  sha256 "8fb1b0a47ed4e1f9d7c70129d7993aa650da1688fd931b10646d1c4707ae234d"

  bottle do
    sha256 "141a227a417c9b0fbf77757aa88f66cf90cc8ed3b6f2bc74e144a79fab7ca91b" => :sierra
    sha256 "ebb0b0c0b1054176fe2f10473add3c8076ae777f26f2a6b81089dca4d21f1afc" => :el_capitan
    sha256 "679e25baca499bde02c11ed993a9eca1b7738f3f21804e9f817c63ddb06d3386" => :yosemite
  end

  option "with-gsl", "Enable polysomy command. Makes licence GPL3 not MIT/Expat."

  deprecated_option "with-polysomy" => "with-gsl"

  depends_on "xz"
  depends_on "samtools" => :recommended
  depends_on "gsl" => :optional

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

class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.4.1/bcftools-1.4.1.tar.bz2"
  sha256 "d7d0871846005c653f5e2e78e434f7f9b846ab245ab5c1cd4224ecbf52d99d08"

  bottle do
    sha256 "1ff54e0673300dd10e955f506c72d95d230977799156929b22c24889080b1401" => :sierra
    sha256 "27d79f1244ec79a028c9a8432def58ad906fc8ff3661c72f51d5d8d8808db11a" => :el_capitan
    sha256 "bba50d9490ae5f7b671ef24ee0bf11a41b858d0642aad31d644b4291fa4c94f6" => :yosemite
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

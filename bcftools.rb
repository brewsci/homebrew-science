class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.4/bcftools-1.4.tar.bz2"
  sha256 "8fb1b0a47ed4e1f9d7c70129d7993aa650da1688fd931b10646d1c4707ae234d"

  bottle do
    sha256 "aa497ce3f323c1d84ab6f9fd52bad51764ac647503c31c2cd031aef3b3d6c98e" => :el_capitan
    sha256 "2bbbe29afa371c40aaee36cc332eae394cca899ca02d34acdbae1e5adf047773" => :yosemite
    sha256 "3e3bc6bec1399dd5c5baf0a4486dde24c1f8f4aad1b273232b2745b1784bd03d" => :mavericks
    sha256 "538d88065ed818fb4e9d997e7e7bb41b4bd6a5559600fbffe4585dd6bcf5879c" => :x86_64_linux
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

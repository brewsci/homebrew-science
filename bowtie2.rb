class Bowtie2 < Formula
  desc "A fast and sensitive gapped read aligner"
  homepage "http://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  # doi "10.1038/nmeth.1923"
  # tag "bioinformatics"
  head "https://github.com/BenLangmead/bowtie2.git"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.2.6.tar.gz"
  sha256 "fb4d09a96700cc929e8191659ee8509bb2f19816235322d1f012338d4a177358"

  bottle do
    cellar :any
    sha256 "7a3109ba175caf7028d398ba5055c0164a064a9fd05b2ed1a79ff74c8f0d26ab" => :yosemite
    sha256 "afe2ec32c42abfac1229d0bd129f80719d4ba95747c4b27656709a861facadfd" => :mavericks
    sha256 "7508c69abdfeedf24599942e162c302e7f1c1e0815830011ced2dc85db1f22c1" => :mountain_lion
  end

  depends_on "tbb"

  def install
    system "make", "install", "WITH_TBB=1", "prefix=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "bowtie2-build", "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end

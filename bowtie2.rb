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
    revision 1
    sha256 "228edcb384d3854fe3954fcfdd3856470be97356c92787ad7931aa9bf1b705d0" => :yosemite
    sha256 "34b8f416f4761fbcbde9b6336a41f20be02bb7cef86fbf968379f28f8d6a178f" => :mavericks
    sha256 "6b775646d6b84ff565536b10ae3ce7b3ab47a2c935f8120bc31a2cdf8d77c8ea" => :mountain_lion
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

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
    sha256 "67239a1075d5116d7833b0a04b18c9efed3f4fb27510a9dfc0546d52afce0a63" => :yosemite
    sha256 "0c84c5e5505dc7ef83c7da6ba691948cebf2c9cd68a0b051dd67e347908f9eea" => :mavericks
    sha256 "fd0bda8aec4d0d9a1f9b433d465fed2c026d1b88ea44688315fbde892d9d64a9" => :mountain_lion
  end

  depends_on "tbb"

  def install
    system "make", "install", "WITH_TBB=1", "prefix=#{prefix}"
    share.install "example", "scripts"
  end

  test do
    system "bowtie2-build", "#{share}/example/reference/lambda_virus.fa", "lambda_virus"
    assert File.exist?("lambda_virus.1.bt2")
  end
end

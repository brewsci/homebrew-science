class Last < Formula
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-752.zip"
  sha256 "e2e8efc1ce1ec9b20cb3554126bf7a86a62fff712a07e156b414554283236ed5"
  head "http://last.cbrc.jp/last", :using => :hg
  # doi "10.1101/gr.113985.110"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "9cd5e65821807e813ca092e74c829d0603b5af3ada0a61358a00bb268aabfa7f" => :yosemite
    sha256 "d35f171412e0b6a91f2107a10241a6fd06d2426a24c6d3f18184cd7b3650cef5" => :mavericks
    sha256 "a1e551765c684464924b862620f0cfc72854c11a14d2a17f614f8e3dd00af1ba" => :mountain_lion
    sha256 "73453a2c736714854ad40075bbdd26cc0549682137dcbfa407fe4f4ca62fc4d5" => :x86_64_linux
  end

  resource "mito" do
    url "http://last.cbrc.jp/tutorial/files/human-mito.fasta"
    sha256 "0bb98fa7d77160c60773b27d1aa5730bd3447d6b4363fb2511565887538678ce"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install Dir["*.txt", "doc/*"], "examples"
  end

  test do
    resource("mito").stage do
      system bin/"lastdb", "test-index", "human-mito.fasta"
    end
  end
end

class Last < Formula
  desc "LAST finds similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  # doi "10.1101/gr.113985.110"
  # tag "bioinformatics"

  url "http://last.cbrc.jp/last-581.zip"
  sha256 "8a25ca32585df56160214445195ce29861824ed570fe25e2344015f59fd81b0a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "9cd5e65821807e813ca092e74c829d0603b5af3ada0a61358a00bb268aabfa7f" => :yosemite
    sha256 "d35f171412e0b6a91f2107a10241a6fd06d2426a24c6d3f18184cd7b3650cef5" => :mavericks
    sha256 "a1e551765c684464924b862620f0cfc72854c11a14d2a17f614f8e3dd00af1ba" => :mountain_lion
  end

  head "http://last.cbrc.jp/last", :using => :hg

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

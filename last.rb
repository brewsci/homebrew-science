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
    sha256 "54162ea841730fb32fe67de564d940c45248031944d4ce53e742b925a529c882" => :yosemite
    sha256 "2ae17f897ca784c3bde7762952d27e14c982b1f54a1769a1e33b0a6d137cc8c6" => :mavericks
    sha256 "9bd5be1e2e0a013f8927bd6a5150f08db8bc3496be13e791e2fd3a232bea6425" => :mountain_lion
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

class Last < Formula
  homepage "http://last.cbrc.jp/"
  #doi "10.1101/gr.113985.110"
  url "http://last.cbrc.jp/last-548.zip"
  sha256 "a76e807cb169a2c4a2b23a859e6955f925771687fb53362ee45899f7282cb6d4"
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

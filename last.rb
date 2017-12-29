class Last < Formula
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-916.zip"
  sha256 "57f9155f26b4b81d39d4a9d230df8080c8a8d366b5585ab3574340b790cfec88"
  head "http://last.cbrc.jp/last", :using => :hg
  # doi "10.1101/gr.113985.110"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "74d5bd73e6caa407045bd965ce269d38af02de252cb734862e5e3175c6223930" => :high_sierra
    sha256 "473b6c50184bdc10e12d789706dd72081305330075278034524fa96e262531b2" => :sierra
    sha256 "1599151f147caa774395b2bdb310a5db82b960853a8a90b2427f010f74988f5c" => :el_capitan
    sha256 "52073658f8f52b9b35d6d1a498230417f6abd418b6d3c1f1a2e4681fae2a831b" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

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

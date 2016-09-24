class Last < Formula
  desc "Find similar regions between sequences"
  homepage "http://last.cbrc.jp/"
  url "http://last.cbrc.jp/last-752.zip"
  sha256 "e2e8efc1ce1ec9b20cb3554126bf7a86a62fff712a07e156b414554283236ed5"
  head "http://last.cbrc.jp/last", :using => :hg
  # doi "10.1101/gr.113985.110"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "42425823c96441555576551dfcde5b343c2c2f5236f59262a5eb8284a890bb2b" => :el_capitan
    sha256 "8b6623e595b0219cf4747766793a97597048e2859224c2cbfc4cc0688f97454a" => :yosemite
    sha256 "c1851700dac785895aa0bbea9d0dc31ba8c33b9913933cab2df9e93ebaaa9085" => :mavericks
    sha256 "bbe981e9a0b324301e75656d8568db46ef6e2c560fa5f819017aa95a1259b78c" => :x86_64_linux
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

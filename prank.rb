class Prank < Formula
  desc "A multiple alignment program for DNA, codon and amino-acid sequences"
  homepage "http://wasabiapp.org/software/prank/"
  url "http://wasabiapp.org/download/prank/prank.source.170427.tgz"
  sha256 "623eb5e9b5cb0be1f49c3bf715e5fabceb1059b21168437264bdcd5c587a8859"

  head "https://github.com/ariloytynoja/prank-msa.git"

  bottle do
    cellar :any
    sha256 "645b55928f814076559c0515ba5760006efbd6352d9599c09f769e5b05d9441a" => :yosemite
    sha256 "c935677f529955560e10caedadaa2294e7df2a29559691c8bd5c4f4406b782d7" => :mavericks
    sha256 "126c9194604ebf8af867ad12e7c621ff271ae7d17fa47dc509941ceb681eb263" => :mountain_lion
    sha256 "3f9b5ba80cf44800d5bfec891de6ee5e37b00d5ec8dae8bcaa5f2ce7539e38d8" => :x86_64_linux
  end

  depends_on "mafft"
  depends_on "exonerate"

  def install
    cd "src" do
      system "make"
      bin.install "prank"
      man1.install "prank.1"
    end
  end

  test do
    system "#{bin}/prank", "-help"
  end
end

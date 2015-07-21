require "formula"

class Novoalign < Formula
  homepage "http://www.novocraft.com/"
  #tag "bioinformatics"

  version "3.02.13"
  url "http://www.novocraft.com/homebrew/novocraftV%s.%s.tar.gz" %
    [version, if OS.mac? then "MacOSX" else "Linux2.6" end]
  sha256(if OS.mac? then "cb51ac1f7ffa96b528fea18c4b9f9b16a7ebd195efddd20caa54a251e2c19e76"
      elsif OS.linux? then "e2cce841c44638ac93704c6f51c5390cf116d7aca7a77cc4551cb2aeceebf47d"
    else raise "Unknown operating system"
    end)
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "def48a21b0cf4f896a35f22813096f348b0d2d1f" => :yosemite
    sha1 "503ecf71abb71665fafcbab59a605cc564d64703" => :mavericks
    sha1 "449919f5a2514b4936b867d701ef487bf73a5d4d" => :mountain_lion
  end

  def install
    bin.install %w[isnovoindex novo2paf novoalign novoalignCS
      novoalignCSMPI novoalignMPI novobarcode novoindex novomethyl
      novope2bed.pl novorun.pl novosort novoutil]
    # Conflicts with samtools
    #bin.install "novo2sam.pl"
    doc.install Dir["*.pdf", "*.txt"]
  end

  test do
    system "#{bin}/novoalign --version 2>&1 |grep -q Novoalign"
  end
end

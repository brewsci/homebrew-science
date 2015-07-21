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
    cellar :any
    sha256 "e900cd36677ec495d0c6fa3a84e0700bd35680c509b28e2528b18fe40a0aa00b" => :yosemite
    sha256 "c4fd0e6b46ea57ec09014ea58f967229947dda33559bafdc93166ca4f797f30c" => :mavericks
    sha256 "0cdd8d02f923178f69f96296a768bc40e7772a796bd4c2ab0da2812ba3b21385" => :mountain_lion
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

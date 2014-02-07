require 'formula'

class Novoalign < Formula
  homepage 'http://www.novocraft.com/'
  version '3.02.02'
  url 'http://www.novocraft.com/homebrew/novocraftV%s.%s.tar.gz' %
    [version, if OS.mac? then 'MacOSX' else 'Linux2.6' end]
  sha1(if OS.mac? then '97984fbf7a7d5f73e47e5a44523812ea1c2f6ee6'
    else 'f16ce82c9d6c4e7559101f819320e7fd39352a75' end)

  def install
    bin.install %w[isnovoindex novo2paf novoalign novoalignCS
      novoalignCSMPI novoalignMPI novobarcode novoindex novomethyl
      novope2bed.pl novorun.pl novosort novoutil]
    # Conflicts with samtools
    #bin.install 'novo2sam.pl'
    doc.install Dir['*.pdf', '*.txt']
  end

  test do
    system 'novoalign --version 2>&1 |grep -q Novoalign'
  end
end

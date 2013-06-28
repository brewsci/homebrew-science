require 'formula'

class Novoalign < Formula
  homepage 'http://www.novocraft.com/'
  version '3.00.05'
  url 'http://www.novocraft.com/homebrew/novocraftV%s.%s.tar.gz' %
    [version, if MACOS then 'MacOSX' else 'gcc' end]
  sha1(if MACOS then 'fde9f3e0d5aeb0fd6b7ac81e61c4a0163c19b2d7'
    else 'e3856070e91a86e693f14d36c16b478f4cc4b80d' end)

  def install
    bin.install %w[isnovoindex novo2maq novo2paf novoalign novobarcode
      novoindex novomethyl novope2bed.pl novorun.pl novosort novoutil]
    # Conflicts with samtools
    #bin.install 'novo2sam.pl'
    doc.install Dir['*.pdf', '*.txt']
  end

  test do
    system 'novoalign --version 2>&1 |grep -q Novoalign'
  end
end

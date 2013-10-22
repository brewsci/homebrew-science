require 'formula'

class Novoalign < Formula
  homepage 'http://www.novocraft.com/'
  version '3.02.00'
  url 'http://www.novocraft.com/homebrew/novocraftV%s.%s.tar.gz' %
    [version, if OS.mac? then 'MacOSX' else 'Linux2.6' end]
  sha1(if OS.mac? then '1a3f89f6dd9cd33d61ac143d622a8394dcd69b65'
    else '4877eef6b236f2a00d47faf2adc74b2d313c5260' end)

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

require 'formula'

class Bwtdisk < Formula
  homepage 'http://people.unipmn.it/manzini/bwtdisk/'
  url 'http://people.unipmn.it/manzini/bwtdisk/bwtdisk.0.9.0.tgz'
  sha1 '4cdfd9fc826df7c11abb45ccd802e3f71c64901c'

  def install
    system 'make'
    bin.install %w'bwte text_conv text_count text_rev unbwti'
    doc.install %w'CHANGES COPYING README doc/bwtdisk.pdf'
    include.install 'bwtext_defs.h'
    lib.install 'bwtext.a' => 'libbwtext.a'
  end

  test do
    system "#{bin}/bwte 2>&1 |grep -q bwte"
  end
end

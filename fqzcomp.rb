require 'formula'

class Fqzcomp < Formula
  homepage 'https://sourceforge.net/projects/fqzcomp/'
  #doi '10.1371/journal.pone.0059190'
  #tag 'bioinformatics'
  url 'https://downloads.sourceforge.net/project/fqzcomp/fqzcomp-4.6.tar.gz'
  sha1 'fa5554747f1d49d1ae2303d6302822416bc318b3'

  def install
    system "make"
    bin.install 'fqz_comp'
    doc.install 'README'
  end

  test do
    system "#{bin}/fqz_comp -h"
  end
end

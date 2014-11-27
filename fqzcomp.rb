require 'formula'

class Fqzcomp < Formula
  homepage 'https://sourceforge.net/projects/fqzcomp/'
  #doi '10.1371/journal.pone.0059190'
  #tag 'bioinformatics'
  url 'https://downloads.sourceforge.net/project/fqzcomp/fqzcomp-4.6.tar.gz'
  sha1 'fa5554747f1d49d1ae2303d6302822416bc318b3'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "aa5291bcf4d404845336542ba27471465bafb3ce" => :yosemite
    sha1 "f9eebf34264c2d8ae4834db317c418ea05ea9e8f" => :mavericks
    sha1 "53d2378664bc0dfceb31388d4fb4dad9093751f2" => :mountain_lion
  end

  def install
    system "make"
    bin.install 'fqz_comp'
    doc.install 'README'
  end

  test do
    system "#{bin}/fqz_comp -h"
  end
end

require 'formula'

class Idcoefs < Formula
  homepage 'http://code.google.com/p/idcoefs/'
  url 'https://idcoefs.googlecode.com/files/Idcoefs2_1_1.tar.gz'
  sha1 'c8b4b8fcd7518628fce46333d30ab246e85a3ff3'

  def install
    system 'make'
    bin.install('idcoefs')
    doc.install('Example')
  end

  test do
    system "#{bin}/idcoefs",
             '-p', "#{doc}/Example/ex.pedigree",
             '-s', "#{doc}/Example/ex.study",
             '-o', 'foo.out'
    system 'diff', 'foo.out', "#{doc}/Example/ex.output"
  end
end

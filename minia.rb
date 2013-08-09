require 'formula'

class Minia < Formula
  homepage 'http://minia.genouest.org/'
  url 'http://minia.genouest.org/files/minia-1.5418.tar.gz'
  sha1 '25299d6d236b80c044f153c101c4266c88698a87'

  def install
    system 'make'
    bin.install 'minia'
    doc.install 'README', 'manual/manual.pdf'
  end

  test do
    system 'minia 2>&1 |grep -q minia'
  end
end

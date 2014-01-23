require 'formula'

class Minia < Formula
  homepage 'http://minia.genouest.org/'
  url 'http://minia.genouest.org/files/minia-1.6088.tar.gz'
  sha1 'ce3252e4fce9c86d3bba9cac9a3a90f50cfb3284'

  def install
    system 'make'
    bin.install 'minia'
    doc.install 'README', 'manual/manual.pdf'
  end

  test do
    system 'minia 2>&1 |grep -q minia'
  end
end

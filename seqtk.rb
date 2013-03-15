require 'formula'

class Seqtk < Formula
  homepage 'https://github.com/lh3/seqtk'
  head 'https://github.com/lh3/seqtk.git'

  def install
    system 'make'
    bin.install 'seqtk'
  end

  test do
    system 'seqtk 2>&1 |grep -q seqtk'
  end
end

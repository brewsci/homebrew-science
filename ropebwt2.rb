require 'formula'

class Ropebwt2 < Formula
  homepage 'https://github.com/lh3/ropebwt2'
  url 'https://github.com/lh3/ropebwt2/archive/d1c4de8.tar.gz'
  version 'r132'
  sha1 '753fde5c0025ea06c38c8b759158a6a86ea080f6'
  head 'https://github.com/lh3/ropebwt2.git'

  def install
    system 'make'
    bin.install 'ropebwt2'
    doc.install 'README.md', 'tex/ropebwt2.tex'
  end

  test do
    system 'ropebwt2 2>&1 |grep -q ropebwt2'
  end
end

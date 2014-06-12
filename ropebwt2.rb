require 'formula'

class Ropebwt2 < Formula
  homepage "https://github.com/lh3/ropebwt2"
  head "https://github.com/lh3/ropebwt2.git"
  #pdf "http://arxiv.org/pdf/1406.0426v1.pdf"

  url "https://github.com/lh3/ropebwt2/archive/49b280debe54db51d9ca81972a9db76c2f6290f7.tar.gz"
  version "r181"
  sha1 "0a0dba614a1e65a6296bbc23d1c72fb1718065f8"

  def install
    system 'make'
    bin.install 'ropebwt2'
    doc.install 'README.md', 'tex/ropebwt2.tex'
  end

  test do
    system 'ropebwt2 2>&1 |grep -q ropebwt2'
  end
end

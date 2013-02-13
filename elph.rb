require 'formula'

class Elph < Formula
  homepage 'http://cbcb.umd.edu/software/ELPH/'
  url 'ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-1.0.1.tar.gz'
  sha1 '9c8bf6ac54ade29daa15dc07aeeb94747626298a'

  def install
    cd 'sources' do
      system 'make'
      bin.install 'elph'
    end
  end

  def test
    system "#{bin}/elph -h 2>&1 | grep elph"
  end
end

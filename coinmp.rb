require 'formula'

class Coinmp < Formula
  homepage 'http://www.coin-or.org/projects/CoinMP.xml'
  url 'http://www.coin-or.org/download/source/CoinMP/CoinMP-1.6.0.tgz'
  sha1 '1f9dd57e4cdb4d0fa1594851ae411d366c3e8836'

  depends_on :fortran

  conflicts_with 'coinutils', :because => 'CoinMP includes CoinUtils.'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize  # make install fails in parallel.
    system "make install"

    # The following hack should be fixed upstream soon.
    (include+'coin').install Dir['Clp/src/*.hpp']
  end
end

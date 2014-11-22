require 'formula'

class Coinutils < Formula
  homepage 'http://www.coin-or.org/projects/CoinUtils.xml'
  url 'http://www.coin-or.org/download/source/CoinUtils/CoinUtils-2.9.0.tgz'
  sha1 '2748dbae9db3df3818d56016ef964e82a942d697'
  revision 1

  depends_on :fortran

  conflicts_with 'coinmp', :because => 'CoinMP already provides CoinUtils (and more).'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize  # make install fails in parallel.
    system "make install"
  end
end

require 'formula'

class Coinutils < Formula
  homepage 'http://www.coin-or.org/projects/CoinUtils.xml'
  url 'http://www.coin-or.org/download/source/CoinUtils/CoinUtils-2.8.8.tgz'
  sha1 '64791e9c5f2dc50b891dd2b0d710ddf81d302864'

  conflicts_with 'coinmp', :because => 'CoinMP already provides CoinUtils (and more).'

  def install
    ENV.fortran

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize  # make install fails in parallel.
    system "make install"
  end
end

require 'formula'

class Coinmp < Formula
  homepage 'http://www.coin-or.org/projects/CoinMP.xml'
  url 'http://www.coin-or.org/download/source/CoinMP/CoinMP-1.7.3.tgz'
  sha1 'a40a7c9b4a63eea63a4e3f81c5a3ab3a9d77bf4c'
  head 'https://projects.coin-or.org/svn/CoinMP/trunk', :using => :svn
  revision 1

  depends_on :fortran

  conflicts_with 'coinutils', :because => 'CoinMP includes CoinUtils.'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize  # make install fails in parallel.
    system "make"
    system "make test"
    system "make install"
  end
end

class Coinmp < Formula
  desc "C-API library for the CLP, CBC and CGL projects"
  homepage "https://projects.coin-or.org/CoinMP"
  url "https://www.coin-or.org/download/source/CoinMP/CoinMP-1.7.3.tgz"
  sha256 "45c349e297edfa951458f37800ba16aa451aff86fea2de2923e15723b3909f90"
  revision 2
  head "https://projects.coin-or.org/svn/CoinMP/trunk", :using => :svn

  depends_on :fortran

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize # make install fails in parallel.
    system "make"
    system "make", "test"
    system "make", "install"
  end
end

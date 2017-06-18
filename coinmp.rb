class Coinmp < Formula
  desc "C-API library for the CLP, CBC and CGL projects"
  homepage "https://projects.coin-or.org/CoinMP"
  url "https://www.coin-or.org/download/source/CoinMP/CoinMP-1.7.3.tgz"
  sha256 "45c349e297edfa951458f37800ba16aa451aff86fea2de2923e15723b3909f90"
  revision 2
  head "https://projects.coin-or.org/svn/CoinMP/trunk", :using => :svn

  bottle do
    cellar :any
    sha256 "018f7377a5f925efe0aabfef889f202f68f43438e54b1196d1654d4269f4a77e" => :sierra
    sha256 "b1a941e0f12febbb3c23b4f1d41c4ec12c5ed49527e00eb0043bb42352c2f28f" => :el_capitan
    sha256 "7389173e25314264784ef64fec843068de566c33dde2519070e9aec46161906f" => :yosemite
    sha256 "752a68fa35e890c14ec23dcc2abc8bc7c604ab9fdcf4c7046d8f9856aa6f5d95" => :x86_64_linux
  end

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

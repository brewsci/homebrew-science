class Mpsolve < Formula
  homepage "http://www.dm.unipi.it/cluster-pages/mpsolve/index.htm"
  url "http://www.dm.unipi.it/cluster-pages/mpsolve/mpsolve.tgz"
  version "2.2"
  sha256 "2b3ad94d9ba88492fedb7c33c8084aa14e97acb5c90e5a0558ed79ef29c9230f"

  depends_on "gmp"

  def install
    system "make"
    bin.install "unisolve"
  end
end

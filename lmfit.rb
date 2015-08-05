class Lmfit < Formula
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
  url "http://apps.jcns.fz-juelich.de/src/lmfit/old/lmfit-5.1.tgz"
  sha256 "4e35bdec551a4985cf6d96f26a808b56c171433edf4a413c2ed50ab3d85a3965"

  bottle do
    cellar :any
    sha256 "b69fe2a022971d23ee059d53da74aaaaf8f9e6cbd48ebd1a6424908c5d144d68" => :yosemite
    sha256 "6cd613bbec25eb2136d0c2d41c0da9ad03e02ecc7768c31f5b52e2d43db92a5d" => :mavericks
    sha256 "298d225772025896c6df53a0f88c01fb25fb23d0d6b3cd0eba8c0ac48daceda2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"demos").install Dir["demo/*.c"]
  end

  def caveats
    "Demo sources have been placed in " + (share/"lmfit/demos")
  end

  test do
    # curve1.c tests lmcurve.h
    system ENV.cc, (pkgshare/"demos/curve1.c"), "-I#{include}", "-L#{lib}", "-llmfit", "-o", "curve1"
    system "./curve1"
    # surface1.c tests lmmin.h
    system ENV.cc, (pkgshare/"demos/surface1.c"), "-I#{include}", "-L#{lib}", "-llmfit", "-o", "surface1"
    system "./surface1"
  end
end

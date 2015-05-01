class Lmfit < Formula
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
  url "http://apps.jcns.fz-juelich.de/src/lmfit/old/lmfit-5.1.tgz"
  sha256 "4e35bdec551a4985cf6d96f26a808b56c171433edf4a413c2ed50ab3d85a3965"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (share/"lmfit/demos").install Dir["demo/*.c"]
  end

  def caveats
    "Demo sources have been placed in " + (share/"lmfit/demos")
  end

  test do
    # curve1.c tests lmcurve.h
    system ENV.cc, (share/"lmfit/demos/curve1.c"), "-I#{include}", "-L#{lib}", "-llmfit", "-o", "curve1"
    system "./curve1"
    # surface1.c tests lmmin.h
    system ENV.cc, (share/"lmfit/demos/surface1.c"), "-I#{include}", "-L#{lib}", "-llmfit", "-o", "surface1"
    system "./surface1"
  end
end

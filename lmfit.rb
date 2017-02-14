class Lmfit < Formula
  desc "Levenberg-Marquardt least-squares minimization and curve fitting."
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
  url "http://apps.jcns.fz-juelich.de/src/lmfit/lmfit-6.1.tgz"
  sha256 "54366788400e3b1eb47cff44c9dae9906da079400cec2df2fb0b865c9e04c6a0"

  bottle do
    cellar :any
    sha256 "454e223c39a4a049c9001584137077147f85d12a3657c10d6888b4db8415106d" => :sierra
    sha256 "4998c7cfa91014494c02dc1601c11951348b999269d6fed9cd1a4cc50283608e" => :el_capitan
    sha256 "85cd1061ef09f90b819f611d4b1e86a81f04e88e49f9c67e674cf47b171c484c" => :yosemite
    sha256 "9fbd898fc70d99e318676e1d32f0802f522019453bb6cea594353df604345e97" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"demos").install Dir["demo/*.c"]
  end

  def caveats
    "Demo sources have been placed in " + (pkgshare/"lmfit/demos")
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

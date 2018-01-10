class Lmfit < Formula
  desc "Levenberg-Marquardt least-squares minimization and curve fitting."
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
  url "http://apps.jcns.fz-juelich.de/src/lmfit/lmfit-6.4.tgz"
  sha256 "a667572ebd0d7474451a1bdde69e76f0965ddb3b4f0640585e6f5d65cb8554c2"

  bottle do
    cellar :any
    sha256 "bbd8fe5551040242d4520c43760f5425905b9cdd2a684002a204dc9ef377a481" => :high_sierra
    sha256 "5f77f709999d25f8e3ee4b1d610890ffe818e0888a7fef02b9de914210aa75e8" => :sierra
    sha256 "581ff0bf574fa30729fcd1da007d004e7c26af2ce0f014db46d99de984c4257a" => :el_capitan
    sha256 "8f312bd7912995ee7232f8dc5654810e9083c6e27d506c482f7ef552f2a78961" => :x86_64_linux
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

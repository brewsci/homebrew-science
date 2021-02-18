class Lmfit < Formula
  desc "Levenberg-Marquardt least-squares minimization and curve fitting"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
  url "http://apps.jcns.fz-juelich.de/src/lmfit/lmfit-6.4.tgz"
  sha256 "a667572ebd0d7474451a1bdde69e76f0965ddb3b4f0640585e6f5d65cb8554c2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-science"
    sha256 cellar: :any, high_sierra:  "bbd8fe5551040242d4520c43760f5425905b9cdd2a684002a204dc9ef377a481"
    sha256 cellar: :any, sierra:       "5f77f709999d25f8e3ee4b1d610890ffe818e0888a7fef02b9de914210aa75e8"
    sha256 cellar: :any, el_capitan:   "581ff0bf574fa30729fcd1da007d004e7c26af2ce0f014db46d99de984c4257a"
    sha256 cellar: :any, x86_64_linux: "8f312bd7912995ee7232f8dc5654810e9083c6e27d506c482f7ef552f2a78961"
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

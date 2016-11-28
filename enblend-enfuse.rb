class EnblendEnfuse < Formula
  homepage "http://enblend.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/enblend/enblend-enfuse/enblend-enfuse-4.1/enblend-enfuse-4.1.1.tar.gz"
  sha256 "9d0947633ebaa0dc1211331b31009408de6fe2108751ad4190760e3a9f181bc9"
  revision 3

  bottle do
    cellar :any
    sha256 "e973764066c5be54a542a90a6d5c240735a353573f978c1c475dbe5d6741618f" => :sierra
    sha256 "c21addb137d220955450f52ca1e4d1e796f2078062df684026fb8c4ea42f2dd8" => :el_capitan
    sha256 "0ddee6656048b6e8a6fcb4e3c423bf02f016cc0dc611eefaa55afa8b4fefac7a" => :yosemite
  end

  option "with-gpu", "Build with GPU support"

  depends_on "libpng"
  depends_on :x11 => :optional
  depends_on "boost"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "little-cms2"
  depends_on "libtiff"
  depends_on "vigra"
  depends_on "openexr" => :optional

  # builds against the multithreaded boost system library
  patch :DATA

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    args << "--without-x" if build.without? "x11"
    args << "--enable-gpu-support=" + ((build.with? "gpu") ? "yes" : "no")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/enblend", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"

    system "#{bin}/enfuse", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"
  end
end

__END__
diff --git a/configure.orig b/configure
index 98699f5..70e286b 100755
--- a/configure.orig
+++ b/configure
@@ -8279,7 +8279,7 @@ fi
 
 
 
-LIBS="-lboost_system $LIBS"
+LIBS="-lboost_system-mt $LIBS"
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for new Boost system library" >&5
 $as_echo_n "checking for new Boost system library... " >&6; }
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext

class Gnudatalanguage < Formula
  desc "Free and open-source IDL/PV-WAVE compiler"
  homepage "http://gnudatalanguage.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.7/gdl-0.9.7.tgz"
  sha256 "2b5945d06e4d95f01cb70a3c432ac2fa4c81e1b3ac7c02687a6704ab042a7e21"

  bottle do
    sha256 "a7c70e56aabf01d9c9c9ea702698c156f8733383e921784bc095f8115243660e" => :sierra
    sha256 "5c594bba8d4a7520fab75afec4047e2b4b88ef12a8037ea25e5d6a2e7e6bd30c" => :el_capitan
    sha256 "c9fde2bf680fc3a1a6022a54aa68d64418b6d2cf8b31ee8e46501fb9972fe1fd" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "plplot" => "with-x11"
  depends_on "gsl"
  depends_on "readline"
  depends_on "graphicsmagick"
  depends_on "netcdf"
  depends_on "homebrew/versions/hdf4" => :optional
  depends_on "hdf5"
  depends_on "libpng"
  depends_on "udunits"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "eigen"
  depends_on :x11
  depends_on :python => :optional

  patch :DATA if build.with? "hdf4"

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DHDF=OFF" if build.without?("hdf4")
      args << "-DPYTHON=OFF" if build.without?("python")
      args << "-DWXWIDGETS=OFF" << "-DPSLIB=OFF"
      system "cmake", "..", *args
      system "make"

      # The following tests FAILED:
      #    80 - test_execute.pro (Failed)
      #    84 - test_fft_leak.pro (Failed)
      #   108 - test_image_statistics.pro (Failed)
      #   128 - test_obj_isa.pro (Failed)
      # Reported 3 Feb 2017 https://sourceforge.net/p/gnudatalanguage/bugs/716/
      # system "make", "check"

      system "make", "install"
    end
  end

  test do
    system "#{bin}/gdl", "--version"
  end
end

__END__
diff --git a/src/GDLTokenTypes.hpp b/src/GDLTokenTypes.hpp
index 06b9316..a91f226 100644
--- a/src/GDLTokenTypes.hpp
+++ b/src/GDLTokenTypes.hpp
@@ -10,6 +10,10 @@
 #ifdef __cplusplus
 struct CUSTOM_API GDLTokenTypes {
 #endif
+
+#ifdef NOP
+#undef NOP
+#endif
	enum {
		EOF_ = 1,
		ALL = 4,

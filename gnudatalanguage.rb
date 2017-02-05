class Gnudatalanguage < Formula
  desc "Free and open-source IDL/PV-WAVE compiler"
  homepage "http://gnudatalanguage.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.7/gdl-0.9.7.tgz"
  sha256 "2b5945d06e4d95f01cb70a3c432ac2fa4c81e1b3ac7c02687a6704ab042a7e21"
  revision 1

  bottle do
    sha256 "4d3426c636fe4d5597d3cb356c25ba4db2cefc4f7a1e9d735e5f30048630e122" => :sierra
    sha256 "354d7b83f221d10336939fa12fc1d74454eaf64bfdbae422763bcd11875db6ea" => :el_capitan
    sha256 "473bafe1c63be372e327600e8bc9ba3135d259248b905f5df058515c9be7c2cd" => :yosemite
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

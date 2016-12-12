class Gnudatalanguage < Formula
  desc "Free and open-source IDL/PV-WAVE compiler"
  homepage "http://gnudatalanguage.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.5/gdl-0.9.5.tar.gz"
  sha256 "cc9635e836b5ea456cad93f8a07d589aed8649668fbd14c4aad22091991137e2"
  revision 6

  bottle do
    rebuild 1
    sha256 "910610010aaff5a8363e9171d851cc5b6d5b36a090934a9d20c03d8ea378b808" => :sierra
    sha256 "fe1317f732defab4984015c289cf3836dcb03551a9429c54051ad9305f1f317a" => :el_capitan
    sha256 "f42e54a27a4df2ad9b614a79ee5ee4e0bf19d2460fddfc4700e7fe8fcfeba419" => :yosemite
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

  # part 1 taken from macports https://trac.macports.org/browser/trunk/dports/math/gnudatalanguage/files/patch-CMakeLists.txt.diff
  # other parts taken from https://github.com/freebsd/freebsd-ports/tree/master/science/gnudatalanguage/files
  patch :p0 do
    url "https://gist.githubusercontent.com/iml/ee107290ee5cd2850190/raw/83c046bce9facda8c560a8d38ea02913892c4b88/gnudatalanguage.diff"
    sha256 "b2e9b2c1ed51676e048441b7bfc160488fdf5898b1d1c9396bc58eb85996981e"
  end

  # restores compatibility with latest plplot. Patch found upstream at http://sourceforge.net/p/gnudatalanguage/bugs/643/
  patch do
    url "https://gist.github.com/tschoonj/e01c72165fd2cb9a68c9/raw/5143168a04de0d4f8fc6c3621733ce68fe7c6268/gdl-plplot.patch"
    sha256 "937e82f6052aa72576df49046aa57d03593c7ba21d074f2455cd614318b881dd"
  end

  patch :DATA if build.with? "hdf4"

  def install
    args = std_cmake_args
    args << "-DHDF=OFF" if build.without?("hdf4")
    args << "-DPYTHON=OFF" if build.without?("python")
    args << "-DWXWIDGETS=OFF" << "-DPSLIB=OFF"
    system "cmake", ".", *args
    system "make"
    # several tests fail
    # system "make", "check"
    system "make", "install"
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

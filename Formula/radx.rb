class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://github.com/NCAR/lrose-core/releases/download/radx-20171016/radx-20171016.src.tgz"
  version "20171016"
  sha256 "a60dbaf2256fe71f97f444c1fd0e21a59e9340a6f90acc5d7594e8e9c2fd4ef6"

  bottle :disable, "Test-bot cannot use the versioned gcc formulae"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "hdf5"
  depends_on "udunits"
  depends_on "netcdf"
  depends_on "fftw"
  depends_on "bzip2" unless OS.mac?

  patch :DATA if OS.mac?

  fails_with :clang
  fails_with :gcc => "7"
  fails_with :gcc => "6"

  needs :cxx11

  def install
    ENV.cxx11

    cd "codebase"
    system "glibtoolize"
    system "aclocal"
    system "autoconf"
    system "automake", "--add-missing"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RadxPrint", "-h"
  end
end

__END__
diff --git a/codebase/libs/Radx/src/Bufr/BufrProduct.cc b/codebase/libs/Radx/src/Bufr/BufrProduct.cc
index 597e4be..d38f363 100644
--- a/codebase/libs/Radx/src/Bufr/BufrProduct.cc
+++ b/codebase/libs/Radx/src/Bufr/BufrProduct.cc
@@ -222,7 +222,7 @@ double *BufrProduct::decompressData() {
 		 //                 nData) != Z_OK) {
     return NULL;
   }
-#if __BYTE_ORDER == __BIG_ENDIAN
+#if 0
   for (i = 0; i < *ndecomp/sizeof(double); ++i) {
     for (j = 0; j < sizeof(double); ++j) {
       str[j] = UnCompDataBuff[i*sizeof(double)+j];

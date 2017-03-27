class Hdf4 < Formula
  desc "HDF version 4"
  homepage "https://www.hdfgroup.org"
  url "https://www.hdfgroup.org/ftp/HDF/releases/HDF4.2.11/src/hdf-4.2.11.tar.bz2"
  sha256 "bb0e900b8cc6bc89a5730abc97e654e7705e8e1fbc4e0d4477f417822428d99b"
  revision 2

  bottle do
    cellar :any
    sha256 "62b3ff43680a0e8c9a0a4ea6882b71b061f7f0a6e7cc2fb1be855fa366217973" => :sierra
    sha256 "260fb928fdf309391a79755d3fe70d510c712193ea8e9aa6a585ffe8745eec6b" => :el_capitan
    sha256 "fccc9f325d2e532efcc512c5c425efaa21803dedb57ebc95c5069dd7bdb6019f" => :yosemite
    sha256 "556d2115f449ddda4c48c67149597d14abe3fd3319c791fb08d7877eea595557" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "szip"
  depends_on "jpeg"

  # redefine library name to "df" from "hdf".  this seems to be an artifact
  # of using cmake that needs to be corrected for compatibility with
  # anything depending on hdf4.
  patch :DATA

  def install
    ENV["SZIP_INSTALL"] = HOMEBREW_PREFIX

    args = std_cmake_args
    args.concat [
      "-DBUILD_SHARED_LIBS=ON",
      "-DBUILD_TESTING=OFF",
      "-DHDF4_BUILD_TOOLS=ON",
      "-DHDF4_BUILD_UTILS=ON",
      "-DHDF4_BUILD_WITH_INSTALL_NAME=ON",
      "-DHDF4_ENABLE_JPEG_LIB_SUPPORT=ON",
      "-DHDF4_ENABLE_NETCDF=OFF", # Conflict. Just install NetCDF for this.
      "-DHDF4_ENABLE_SZIP_ENCODING=ON",
      "-DHDF4_ENABLE_SZIP_SUPPORT=ON",
      "-DHDF4_ENABLE_Z_LIB_SUPPORT=ON",
      "-DHDF4_BUILD_FORTRAN=OFF",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"

      # Remove stray ncdump executable as it conflicts with NetCDF.
      rm (bin+"ncdump")
      rm (bin+"ncgen")
    end
  end

  def caveats; <<-EOS.undent
      HDF4 has been superseeded by HDF5.  However, the API changed
      substantially and some programs still require the HDF4 libraries in order
      to function.
    EOS
  end
end

__END__
--- a/CMakeLists.txt	2015-02-09 11:43:05.000000000 -0500
+++ b/CMakeLists.txt	2015-06-28 14:05:35.000000000 -0400
@@ -95,7 +95,7 @@
 # Set the core names of all the libraries
 #-----------------------------------------------------------------------------
 set (HDF4_LIB_CORENAME              "hdf4")
-set (HDF4_SRC_LIB_CORENAME          "hdf")
+set (HDF4_SRC_LIB_CORENAME          "df")
 set (HDF4_SRC_FCSTUB_LIB_CORENAME   "hdf_fcstub")
 set (HDF4_SRC_FORTRAN_LIB_CORENAME  "hdf_fortran")
 set (HDF4_MF_LIB_CORENAME           "mfhdf")

class Hdf4 < Formula
  desc "HDF version 4"
  homepage "https://www.hdfgroup.org"
  url "https://www.hdfgroup.org/ftp/HDF/releases/HDF4.2.11/src/hdf-4.2.11.tar.bz2"
  sha256 "bb0e900b8cc6bc89a5730abc97e654e7705e8e1fbc4e0d4477f417822428d99b"
  revision 3

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "870c4bd97456d019e7c0bf95d54cefb03cd64e997453c550ca340cc1fb37c0ff"
    sha256 cellar: :any, el_capitan:   "44bbc921816b8c2002be1e814817199e59410dad2971172e62fce11cfd84d364"
    sha256 cellar: :any, yosemite:     "534c9fd10793bc1f21517092f23edf9087c8afcce59f722ca908d39dcf051db8"
    sha256 cellar: :any, x86_64_linux: "d869697d1b6d08f5a50e3ae5edab34ecc3e9b79b99ffb6a6f57c26b29090eb25"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "szip"

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

  def caveats
    <<~EOS
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

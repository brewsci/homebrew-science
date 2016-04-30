class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.67.tar.gz"
  sha256 "e351c81f7787550d42d45855db394a1702fd17c249ba934bdf4b6abf56281446"

  head "https://github.com/dstndstn/astrometry.net.git"

  option "without-extras", "Don't try to build plotting code (actually it will still try, but homebrew won't halt the install if it fails)"

  depends_on "swig" => :build
  depends_on "pkg-config" => :build
  depends_on "wget"
  depends_on "netpbm"
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "wcslib"
  depends_on "gsl"
  depends_on "cfitsio"

  # from pip
  depends_on "pyfits" => :python
  depends_on "numpy" => :python

  # this formula includes python bindings
  depends_on :python => :recommended

  def install
    ENV.j1
    ENV["INSTALL_DIR"] = prefix.to_s
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"

    system "make"
    system "make", "extra" if build.with? "extras"
    system "make", "py"    if build.with? "python"
    system "make", "install"
  end

  test do
    system "solve-field"
  end
end

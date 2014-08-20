require "formula"

class AstrometryNet < Formula
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.50.tar.gz"
  sha1 "fcf6332b603e1af8f25ce7d6996b5a4b0eeaa687"

  head "https://github.com/dstndstn/astrometry.net.git"

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

  option "without-extras", "Don't try to build plotting code (actually it will still try, but homebrew won't halt the install if it fails)"

  def install
    ENV.j1
    ENV["INSTALL_DIR"] = "#{prefix}"
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"

    system "make"
    system "make extra" if build.with? "extras"
    system "make py"    if build.with? "python"
    system "make install"

  end

  test do
    system "solve-field"
  end
end

class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.56.tar.gz"
  sha256 "7f15e9b1c978fa5dd28638e2bcd0063e3cd0b6f348a75b9df7812ee300229010"

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

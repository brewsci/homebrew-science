class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.70.tar.gz"
  sha256 "e087b26b3f3821e63ba3c4d1f6a5cc342784c5ab938c05d59b75ba91b2866b6a"
  revision 1
  head "https://github.com/dstndstn/astrometry.net.git"

  bottle do
    cellar :any
    sha256 "07c6a8bb50177ee8f7bbd63f8a68b05597fa79761b6630021286487ac10e3084" => :sierra
    sha256 "a53ce6737e0ffa5e823717106f7f5c551381713f80cccc51ce3bf889b228f408" => :el_capitan
    sha256 "dac1286a9a3898eb1a9eb9dcb038ae9f9414ce9a99e160d4261e4d8311b711de" => :yosemite
  end

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

  # this formula includes python bindings
  depends_on :python => :recommended
  depends_on "numpy"

  resource "pyfits" do
    url "https://files.pythonhosted.org/packages/45/98/d6d25932e6a82fa8456d38ab307bfb8945a1e1dd4e896730555e3b61cfc5/pyfits-3.4.tar.gz"
    sha256 "ce0319cf6ef40846c5915202e4c8bd8d293ad85af4b14aa5a60fb285b7538c4b"
  end

  def install
    ENV["INSTALL_DIR"] = prefix
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"

    if build.with? "python"
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      resource("pyfits").stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    system "make"
    system "make", "py" if build.with? "python"
    system "make", "extra" if build.with? "extras"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/solve-field"
  end
end

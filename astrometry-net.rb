class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.70.tar.gz"
  sha256 "e087b26b3f3821e63ba3c4d1f6a5cc342784c5ab938c05d59b75ba91b2866b6a"
  head "https://github.com/dstndstn/astrometry.net.git"

  bottle do
    cellar :any
    sha256 "2750cf5d50d2d5cfb0e900fbd433d4f47e11065661d30f52818a341a8e23487b" => :sierra
    sha256 "c588306f5377aa5fd061d1944846321b8977382a87c7cba6f0d0230e513af47a" => :el_capitan
    sha256 "3d1f809ece4eafeb6729bc84f4ee6f75b0ad5e2fc68e1b6bd95164459a2506ca" => :yosemite
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

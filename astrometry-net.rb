class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.70.tar.gz"
  sha256 "e087b26b3f3821e63ba3c4d1f6a5cc342784c5ab938c05d59b75ba91b2866b6a"
  revision 1
  head "https://github.com/dstndstn/astrometry.net.git"

  bottle do
    cellar :any
    sha256 "070291cc7693691d27f6ca560fd1118fa7386d550a2ed6d3f1fc5e4a0d99e804" => :sierra
    sha256 "0eb0bf91f8cd0323517235ad80e468415beb1fb3671ff692e51f9f854d4e8815" => :el_capitan
    sha256 "3883a70238d2abebdf264744170aae5a13884210abd745d23136252fa73e099f" => :yosemite
    sha256 "e560811ce509a8b097064b1ed8e0381fa9a1135be3b5df6915b425955c6a1f2d" => :x86_64_linux
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

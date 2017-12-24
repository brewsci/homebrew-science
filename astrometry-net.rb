class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.73.tar.gz"
  sha256 "27dcaa820db51cda65c23c71d40ea06bda53e13a658ec8e94b39c65ac6584368"
  head "https://github.com/dstndstn/astrometry.net.git"

  bottle do
    cellar :any
    sha256 "6370ad57a1a5f3a7569caf87201d5a3726dc0181a902c423009a244265d092de" => :high_sierra
    sha256 "1d749e2a0bd3c69012dbf8bfb2e1ac1971f68cc8e932361b57d0354c085f66ca" => :sierra
    sha256 "74a3f7c9ac9a7c3263431194789c691a7f98fc2186fcbec1dbb52aaf9d73db2e" => :el_capitan
    sha256 "c4f85a0037ba25a08f2038ff8b1eeb8d999015484c1f30e7f5479a8f9c6f0418" => :x86_64_linux
  end

  option "without-extras", "Don't try to build plotting code (actually it will still try, but homebrew won't halt the install if it fails)"

  depends_on "swig" => :build
  depends_on "pkg-config" => :build
  depends_on "netpbm"
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "wcslib"
  depends_on "gsl"
  depends_on "cfitsio"
  depends_on "wget" if OS.mac?

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

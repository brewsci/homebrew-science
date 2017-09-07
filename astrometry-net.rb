class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.72.tar.gz"
  sha256 "c9f3c2c70847d8ac835f4eb3cfccdcfe938ad8762acea7dd18acbf84c7e97cb6"
  head "https://github.com/dstndstn/astrometry.net.git"

  bottle do
    cellar :any
    sha256 "0edf86b6e6b416fb8417f7c8647022903a92961eee65a4af95e7956c0a779f92" => :sierra
    sha256 "0ff3186b0f44c4bf2af7e025f32053e33478c58f82f3f5de57f79cc317aa1ddf" => :el_capitan
    sha256 "4942f8e1901a2c25e1a212f8aa31754ac67f4d2b78a076686532bf3b44931d75" => :yosemite
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

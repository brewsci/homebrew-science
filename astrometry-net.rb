class AstrometryNet < Formula
  desc "Automatic identification of astronomical images"
  homepage "http://astrometry.net"
  url "http://astrometry.net/downloads/astrometry.net-0.69.tar.gz"
  sha256 "6a445acfd4ff3c082eb56fcba22ee626b45a98665633710a6b1d4a3edef36f3f"
  head "https://github.com/dstndstn/astrometry.net.git"

  bottle do
    cellar :any
    sha256 "3b35fed63763f9906f710c293a7fbf4485c83bd275e7234799646434806866ad" => :el_capitan
    sha256 "c98c75a1dfee78fda39dfe053c009e2961ad319f4fd763c8ca3a158c26f60086" => :yosemite
    sha256 "7c8aae923454efb2082910ced5d35a0971815f6ea0e33bb3ee99472d389a548d" => :mavericks
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

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/e0/4c/515d7c4ac424ff38cc919f7099bf293dd064ba9a600e1e3835b3edefdb18/numpy-1.11.1.tar.gz"
    sha256 "dc4082c43979cc856a2bf352a8297ea109ccb3244d783ae067eb2ee5b0d577cd"
  end

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
      %w[numpy pyfits].each do |r|
        resource(r).stage do
          system "python", *Language::Python.setup_install_args(libexec)
        end
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

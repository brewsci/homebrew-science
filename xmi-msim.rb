class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-6.0.tar.gz"
  sha256 "26520645d9e524436183090c2b8d3ea67cf1480e3b695b6feedf5790c436ac5c"

  bottle do
    sha256 "de36351cb8eca8086c1d8a56ed2233260adc937eb0b2cf8297ede219685f7483" => :sierra
    sha256 "678abfd88503f0579d3932b5e6a3cfc5204e9de0c765d36b1d516e2b99455437" => :el_capitan
    sha256 "884a274b5853c4466c7fa6490b89182e5dbbdb2efdfc37ffbeade59a2f96184c" => :yosemite
  end

  depends_on :fortran
  depends_on "gsl"
  depends_on "fgsl"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "pkg-config" => :build
  depends_on "xraylib" => "with-fortran"

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-updater",
                          "--disable-mac-integration",
                          "--disable-libnotify"
    system "make", "install"
  end

  def post_install
    ohai "Generating xmimsimdata.h5 – this may take a while"
    mktemp do
      system bin/"xmimsim-db"
      (share/"xmimsim").install "xmimsimdata.h5"
    end
  end

  test do
    system bin/"xmimsim", "--version"
  end
end

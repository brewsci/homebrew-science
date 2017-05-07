class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-6.0.tar.gz"
  sha256 "26520645d9e524436183090c2b8d3ea67cf1480e3b695b6feedf5790c436ac5c"
  revision 1

  bottle do
    sha256 "096aa4292f71062cdac8baa71c4c6c57c60bc3e2fa9ae61a1c8af4984f5faa78" => :sierra
    sha256 "0c19899c102da6c683cae24c359d2babbaa44f0861a21bd0da0e3b1d0eb770a8" => :el_capitan
    sha256 "41127390bbaf61f53f1637316e4e8acb1802305ec9f99acb9ac04925f8c3d487" => :yosemite
    sha256 "3e71528e917cbd50acfbf9299d80c265d6dd034718ca01a91e5af354b239c56b" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on :fortran
  depends_on "gsl"
  depends_on "fgsl"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "xraylib"

  # add support for HDF5 1.10.0
  patch do
    url "https://github.com/tschoonj/xmimsim/commit/1459971313ea4a3cbbfdc87332b91dfcdfc0f3d7.diff"
    sha256 "d5d435a420b0b089f103173a143ad6e94718967257fe835f8cecd32ff19c2bb4"
  end

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

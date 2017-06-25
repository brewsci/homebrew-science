class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-6.0.tar.gz"
  sha256 "26520645d9e524436183090c2b8d3ea67cf1480e3b695b6feedf5790c436ac5c"
  revision 3

  bottle do
    sha256 "c11eb391a2c67312052022c026b525e1239ef5a1155991dbac240116ab5264ef" => :sierra
    sha256 "8cc87ab913774f4adbc1e51ff191ab376d95a8145012a359c02f1889939e1fb8" => :el_capitan
    sha256 "b38a8056de76bd9bf80ec9c2dc1f0f56ebf504285a365d3cb37bc39b338c6f6c" => :yosemite
    sha256 "a42655f0b0b0c80f97652c4b1a35ec41cb904fcb09823ad0c90ce332514bc9f2" => :x86_64_linux
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

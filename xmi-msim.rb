class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-6.0.tar.gz"
  sha256 "26520645d9e524436183090c2b8d3ea67cf1480e3b695b6feedf5790c436ac5c"
  revision 2

  bottle do
    sha256 "c2117d9b6beaafba15f135c7facc932d5e10b7d7d557c3e3cc431791cda06206" => :sierra
    sha256 "8a98fc5dd7a289c4d871dba48011de00d79c58cbdafb338d9b8eaac7e5cbd916" => :el_capitan
    sha256 "ef7da71a935e26c9a57a7c07df548240d22e619501307dc0259d0d2d3ea2c185" => :yosemite
    sha256 "53c371c88c38f47a80878d79b52f68e29e151cd7d6f77fbcc59cac0c3e5ac8a2" => :x86_64_linux
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

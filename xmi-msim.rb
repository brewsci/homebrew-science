class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-7.0.tar.gz"
  sha256 "3e970203a56a116fe0b136a857b91b6c4f001cb69b6ac8f68bd865bb7c688542"

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

class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-5.0.tar.gz"
  sha256 "3503b56bb36ec555dc941b958308fde9f4e550ba3de4af3b6913bc29c2c0c9f1"
  revision 5

  bottle do
    sha256 "85515f865a44e9ff3b96c9a968bbf6a3b9863b2e09dc5daa9fbcbf7170ade973" => :el_capitan
    sha256 "66c3e4505c52a52415a49efc6af1f5944155219940d700f4b164ed3daf323b6e" => :yosemite
    sha256 "5edd0a0a81ae68e1e1134eb948c095c39763fccea3c15cf1eb68de7b90956076" => :mavericks
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
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch do
    url "https://github.com/tschoonj/xmimsim/commit/682ff5b413fc326c1cc8e9931d34bce3e920c798.diff"
    sha256 "bf59bcf0091a8f5b4680ab99e3bd0609bcd6558d79c1b71e0473ecb1ec4d0123"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a810aca/xmi-msim/gsl-2.x.patch"
    sha256 "2e4a5789248b672ba73a0b8a2ba0f75773cf5c3905b7416e5e38864c67303813"
  end

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-updater",
                          "--disable-mac-integration",
                          "--disable-libnotify",
                          "--enable-opencl"
    system "make"

    # this next step can take a long time...
    system "./bin/xmimsim-db"
    system "make", "install"
    (share / "xmimsim").install "xmimsimdata.h5"
  end

  test do
    system "#{bin}/xmimsim", "--version"
  end
end

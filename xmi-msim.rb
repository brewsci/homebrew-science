class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-5.0.tar.gz"
  sha256 "3503b56bb36ec555dc941b958308fde9f4e550ba3de4af3b6913bc29c2c0c9f1"
  revision 8

  bottle do
    sha256 "68903bf3ed8dcc8ab417856f8290055ce5f553f974599391a8be5ed50cc15947" => :sierra
    sha256 "34088fa97e1506d3634fdfc381af85406aaba717aedc0a5c3518c34813b35075" => :el_capitan
    sha256 "b758c6b4c9e779910ac37984ff1169d8b8f6ffed8fe43768d10a7b53e58a854a" => :yosemite
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

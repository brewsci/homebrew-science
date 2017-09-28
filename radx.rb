class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://github.com/NCAR/lrose-core/releases/download/radx-20170920/radx-20170920.src.tgz"
  version "20170920"
  sha256 "15c09c0d4495fb3f5cd1232b86daba93f5f5cc32a7fec852bf626a415363c32c"

  bottle do
    cellar :any
    sha256 "d5fa2965cb9880987ad6218245f94de35757585781fe380e145fedffec5bec60" => :high_sierra
    sha256 "a7bcaed5822987a56e58c5c761f98de67f63f19d9b66b0b74c298fa4f7a57b09" => :sierra
    sha256 "4cbdaa82fcfed6a793e08ee85841160f1edf2b87f579c5f8405c5dd2423ce3d9" => :el_capitan
    sha256 "26f063f678bb319e3a1f1e565757640db053838168b950c8a39dc4cc2f1cae2a" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "hdf5"
  depends_on "udunits"
  depends_on "netcdf"
  depends_on "fftw"
  depends_on "bzip2" unless OS.mac?

  patch do
    # Fixes compilation with hdf5 1.10.0
    # Reported https://github.com/NCAR/lrose-core/issues/8
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/208060e/radx/radx-hdf5.diff"
    sha256 "15f61648400487b03955fbf330322e68ad2b2856be3af96ea8ffad22e338fbd4"
  end

  def install
    cd "codebase"
    system "glibtoolize"
    system "aclocal"
    system "autoconf"
    system "automake", "--add-missing"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RadxPrint", "-h"
  end
end

class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://github.com/NCAR/lrose-core/releases/download/radx-20170315/radx-20170315.src.tgz"
  version "20170315"
  sha256 "2ee2cd5ca6254c6c92df144feca4f4cee6504d1f68c014fbad753cf8324655a2"

  bottle do
    cellar :any
    sha256 "ce5104158b0bfd5feb81b6ff57ca9b45e43f6e70634837d821979cb74311df21" => :sierra
    sha256 "bbd4d6270ef58c00aa66ac4567a621419db98bc24345d8e34eba27edb5255837" => :el_capitan
    sha256 "2853715e744da2b615636fdb485fc6d2eacaaabd93cbb991e0f6b8ac700d03d6" => :yosemite
    sha256 "c3d6699f94686d562fb1cc01bfec85bcbc09b0e8c2f8e9910e91351c247d7eed" => :x86_64_linux
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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3124ede999c9ffd700652d20f0455c97512f84a3/radx/radx-hdf5-20170315.diff?full_index=1"
    sha256 "2d4e424fbe43d776e13a2f3506773145e6947be546a2b50df480b1c594aadcbb"
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

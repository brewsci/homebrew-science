class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://github.com/NCAR/lrose-core/releases/download/radx-20170315/radx-20170315.src.tgz"
  version "20170315"
  sha256 "2ee2cd5ca6254c6c92df144feca4f4cee6504d1f68c014fbad753cf8324655a2"

  bottle do
    cellar :any
    sha256 "7851aa983a1d803ef821e1db62f7d9ca50e9d9a5c9fa787bc4d562bd81eed12a" => :sierra
    sha256 "1bf3a6c30a22db867ab4758e2e3eaf4964aa30962be68ce929c34b0f2c5ea927" => :el_capitan
    sha256 "c4187d595e629fa88a77f6c3e771afdf9820f94a6dc86c0a1e7f874d18ed8afd" => :yosemite
    sha256 "de6ed28ac845a751b0c50ea51fea91a4b744c0636873dc9e88a7965554f698b9" => :x86_64_linux
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

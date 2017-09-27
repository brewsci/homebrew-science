class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://github.com/NCAR/lrose-core/releases/download/radx-20170920/radx-20170920.src.tgz"
  version "20170920"
  sha256 "15c09c0d4495fb3f5cd1232b86daba93f5f5cc32a7fec852bf626a415363c32c"

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

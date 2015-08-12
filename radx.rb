class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/radx-20150808.src.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20150808.src.tgz"
  version "20150808"
  sha256 "e81f734ae857e93813bdd619cd7e57b85a2220c0ef6f20fe9240f5f6775d183c"

  bottle do
    cellar :any
    sha1 "f84eca449e63c907234ae112883e561d4f994976" => :yosemite
    sha1 "ed656da3a3ef58c7d8c4a087f50a30e9051c7f1f" => :mavericks
    sha1 "e79d52832b66700b4e0b73fee0320da29313ee56" => :mountain_lion
  end

  depends_on "hdf5"
  depends_on "udunits"
  depends_on "netcdf" => "with-cxx-compat"
  depends_on "fftw"

  # Prevents build failure on Mac OS X 10.8 and below
  # FIXME: Remove when new version comes out
  patch do
    url "https://gist.githubusercontent.com/tomyun/ee3a910e07c9ccc4610e/raw/3b151798488c5dc7091506a25ac704dad6687e97/radx-fix-sockutil-mac.diff"
    sha256 "19d55b7beb985a6facc75a02a92739c3a4208797eea2cbd0f2353a86c7aa90db"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RadxPrint", "-h"
  end
end

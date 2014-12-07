require "formula"

class Radx < Formula
  homepage "http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/radx-20141123.src.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20141123.src.tgz"
  version "20141123"
  sha1 "3b3899e8f927f8107d8c84596d7713ad5db2dcb5"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "f84eca449e63c907234ae112883e561d4f994976" => :yosemite
    sha1 "ed656da3a3ef58c7d8c4a087f50a30e9051c7f1f" => :mavericks
    sha1 "e79d52832b66700b4e0b73fee0320da29313ee56" => :mountain_lion
  end

  depends_on "hdf5" => "with-cxx"
  depends_on "udunits"
  depends_on "netcdf" => "with-cxx-compat"
  depends_on "fftw"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RadxPrint", "-h"
  end
end

require "formula"

class Radx < Formula
  homepage "http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/radx-20141123.src.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20141123.src.tgz"
  version "20141123"
  sha1 "3b3899e8f927f8107d8c84596d7713ad5db2dcb5"

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

require "formula"

class Radx < Formula
  homepage "http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20140417.src.tgz"
  mirror "http://science-annex.org/pub/radx/radx-20140417.src.tgz"
  version "20140417"
  sha1 "2959154e6c8aea4502dbb9fe98723c54fcd1bf39"

  depends_on "hdf5" => "enable-cxx"
  depends_on "udunits"
  depends_on "netcdf" => "enable-cxx-compat"
  depends_on "fftw"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RadxPrint", "-h"
  end
end

require 'formula'

class Radx < Formula
  homepage 'http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html'
  url 'ftp://ftp.rap.ucar.edu/pub/titan/radx/Radx-20130412.src.tgz'
  version '20130412'
  sha1 'beb3ba8707bd9710e5c2154533b42562681171df'

  depends_on 'hdf5'
  depends_on 'udunits'
  depends_on 'netcdf' => 'enable-cxx-compat'
  depends_on 'fftw'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/RadxPrint", "-h"
  end
end

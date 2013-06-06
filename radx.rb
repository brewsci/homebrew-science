require 'formula'

class Radx < Formula
  homepage 'http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html'
  url 'ftp://ftp.rap.ucar.edu/pub/titan/radx/Radx-20130531.src.tgz'
  version '20130531'
  sha1 '81ca12b7d4d45f16bd2a15f332224f739b9b946d'

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

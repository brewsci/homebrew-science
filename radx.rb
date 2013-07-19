require 'formula'

class Radx < Formula
  homepage 'http://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html'
  url 'ftp://ftp.rap.ucar.edu/pub/titan/radx/Radx-20130712.src.tgz'
  mirror 'ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/Radx-20130712.src.tgz'
  version '20130712'
  sha1 '0d077891b43e363beeb2926e2464760186158568'

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

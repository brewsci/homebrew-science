require 'formula'

class Cdo < Formula
  homepage 'https://code.zmaw.de/projects/cdo'
  url 'https://code.zmaw.de/attachments/download/7220/cdo-1.6.3.tar.gz'
  sha1 '9aa9f2227247eee6e5a0d949f5189f9a0ce4f2f1'

  option 'enable-grib2', 'Compile Fortran bindings'

  depends_on 'netcdf'
  depends_on 'hdf5'
  depends_on 'grib-api' if build.include? 'enable-grib2'

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-netcdf=#{HOMEBREW_PREFIX}",
            "--with-hdf5=#{HOMEBREW_PREFIX}",
            "--with-szlib=#{HOMEBREW_PREFIX}"]

    if build.include? 'enable-grib2'
      args << "--with-grib_api=#{HOMEBREW_PREFIX}"
      args << "--with-jasper=#{HOMEBREW_PREFIX}"
    end

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/cdo", "-h"
  end
end

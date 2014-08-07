require "formula"

class Cdo < Formula
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/7220/cdo-1.6.3.tar.gz"
  sha1 "9aa9f2227247eee6e5a0d949f5189f9a0ce4f2f1"

  option "enable-grib2", "Compile Fortran bindings"

  if build.include? "enable-grib2"
    depends_on "grib-api"
    depends_on "jasper"
  end

  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "szip"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-netcdf=#{Formula["netcdf"].opt_prefix}",
            "--with-hdf5=#{Formula["hdf5"].opt_prefix}",
            "--with-szlib=#{Formula["szip"].opt_prefix}"]

    if build.include? "enable-grib2"
      args << "--with-grib_api=#{Formula["grib-api"].opt_prefix}"
      args << "--with-jasper=#{Formula["jasper"].opt_prefix}"
    end

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/cdo", "-h"
  end
end

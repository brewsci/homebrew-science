require "formula"

class Cdo < Formula
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/7220/cdo-1.6.3.tar.gz"
  sha1 "9aa9f2227247eee6e5a0d949f5189f9a0ce4f2f1"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "5eb3315c9fdf5fe36e9868326011f27cfd4f307a" => :yosemite
    sha1 "cab401ebf39e140b1cf33f804453a552b0d1504c" => :mavericks
    sha1 "e7580783a3b2c604e920db74ed0e51d0cd615d64" => :mountain_lion
  end

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

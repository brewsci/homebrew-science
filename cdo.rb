class Cdo < Formula
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/10198/cdo-1.6.9.tar.gz"
  sha256 "9970a7d5c29a59011fea8df6977e66b7d2a5d2dc8b0723a28ac0237d6e69dea8"

  bottle do
    cellar :any
    revision 1
    sha256 "1e9d7de02098e35922ff3bf411dfb7d7b662ecdb55c959f55e6d727734baa346" => :yosemite
    sha256 "242c2284dd498cb906a68b426e570543d608af3757a8e81425edd6cfa4710a4b" => :mavericks
    sha256 "e3924d07751e5106b0109123753cde5461e038c426817f73ba94822fca95f8da" => :mountain_lion
  end

  option "with-grib2", "Compile Fortran bindings"
  deprecated_option "enable-grib2" => "with-grib2"
  option "with-openmp", "Compile with OpenMP support"

  if build.with? "grib2"
    depends_on "grib-api"
    depends_on "jasper"
  end

  needs :openmp if build.with? "openmp"

  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "szip"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-netcdf=#{Formula["netcdf"].opt_prefix}",
            "--with-hdf5=#{Formula["hdf5"].opt_prefix}",
            "--with-szlib=#{Formula["szip"].opt_prefix}"]

    if build.with? "grib2"
      args << "--with-grib_api=#{Formula["grib-api"].opt_prefix}"
      args << "--with-jasper=#{Formula["jasper"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/cdo", "-h"
  end
end

class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/14686/cdo-1.8.2.tar.gz"
  sha256 "6ca6c1263af2237737728ac937a275f8aa27680507636a6b6320f347c69a369a"

  bottle do
    cellar :any
    sha256 "4c48b582be0e9bf7d7607f029ca002ec490ab9e230de87c57fad275df950cbb9" => :sierra
    sha256 "4d9181952c565989e5aae28ae07998766673bca4368cdb849fd32536e392c5ee" => :el_capitan
    sha256 "f0e3d29696ed4b1ca0de197ddd8df9196836d87ac48c4d51a58434b7c51c08c6" => :yosemite
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
            "--prefix=#{prefix}", "LIBS=-lhdf5",
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

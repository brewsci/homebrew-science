class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/15187/cdo-1.9.0.tar.gz"
  sha256 "df367f8c3abf4ab085bcfc61e0205b28a5ecc69b7b83ba398b4d3c874dd69008"

  bottle do
    cellar :any
    sha256 "4767dc0897ec7dbc651baded5141d722f29413217ff830f01961c2c75a9e4d8d" => :sierra
    sha256 "a39ba567ab6c4e0e23145cb9e1d96bf321c5ef5512b39725abd7f1dfe6baeb46" => :el_capitan
    sha256 "601f3887779ea747abbee94eba006b5586b637b0273fd7ed142fe1ee3f2c2bd0" => :yosemite
    sha256 "3a7d5012555b91198889789f0acb7aefe9f3348bd4d71a1fad7542ce55f8ad57" => :x86_64_linux
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

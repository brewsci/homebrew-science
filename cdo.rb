class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/12070/cdo-1.7.1.tar.gz"
  sha256 "5c24a5cb74dcf6e8b5140c67033868a5a0b641341e3adad3cb4035d5ad6e70a6"
  revision 1

  bottle do
    cellar :any
    sha256 "c7288e3f00f86dc70e1ec7289607c983191225bd63b6a9874036eed9e2774890" => :el_capitan
    sha256 "50dc6e5fa8538ee83101700c2f7c6faa56d0636dc591d2dc9039486d4096f290" => :yosemite
    sha256 "13bc63bf9948307f0d0244715623de029011f1a190a12aab16835a9c4625f7b3" => :mavericks
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

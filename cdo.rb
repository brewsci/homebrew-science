class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/14271/cdo-1.8.1.tar.gz"
  sha256 "c3dd3a986c70e48b7b9cd9658de7794a96f85f25f7c68011fd175ce39abd7f93"

  bottle do
    cellar :any
    sha256 "cb16db1b887d6629c1ca40f75d32147b09670d02ad75a0e1413fdd9033d48032" => :sierra
    sha256 "3f7e2191c319d88347652a61d438fb7712a09f9e2f987f770684e4ff2fcbf5eb" => :el_capitan
    sha256 "69fbb8fb2e6901945b3276c331d032d2587f2d8dac7a0eb9076074606017486e" => :yosemite
    sha256 "f777192396dde0db8cd7513719a429e1ecc1bc8ee5c56605df1012d12e63e019" => :x86_64_linux
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

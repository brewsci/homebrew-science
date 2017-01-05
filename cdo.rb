class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/12070/cdo-1.7.1.tar.gz"
  sha256 "5c24a5cb74dcf6e8b5140c67033868a5a0b641341e3adad3cb4035d5ad6e70a6"
  revision 2

  bottle do
    cellar :any
    sha256 "1a033d3174bda246f69899aba8f8ac42359d187c7058b17d86490f48761328e5" => :sierra
    sha256 "03128d28b085ac7655677b0d16cd18e30121a174565adc38acdb0fd980e1684e" => :el_capitan
    sha256 "06ca0619244d19eea0d6f0800fc94086e6b56b3992470a1769ec69d18329beb6" => :yosemite
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

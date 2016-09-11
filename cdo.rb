class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/12070/cdo-1.7.1.tar.gz"
  sha256 "5c24a5cb74dcf6e8b5140c67033868a5a0b641341e3adad3cb4035d5ad6e70a6"
  revision 1

  bottle do
    cellar :any
    sha256 "4eb12c875c4272c989eece9adc263e9c5dc3570eb22d5e7aa491beb8d1c357c4" => :el_capitan
    sha256 "bc990b0e2bcbf045dc4735743511ad41360fa4e60a4fcaf14532c28d12b439f0" => :yosemite
    sha256 "4df71c5bec3ef01b6d18c3321d276e896dacd3e15e4e3ba64ec85689190f06c2" => :mavericks
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

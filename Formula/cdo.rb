class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/16035/cdo-1.9.2.tar.gz"
  sha256 "d1c5092167034a48e4b8ada24cf78a1d4b84e364ffbb08b9ca70d13f428f300c"

  bottle do
    cellar :any
    sha256 "787310ee2158732c70585046aada3e8d79b77ae47c635505e73e19c5e7caefd6" => :high_sierra
    sha256 "76253eaeb404fd01e949e59d43ec2fba66b2154c7b026ad032ac22f7330513b9" => :sierra
    sha256 "9cc65d5e6a09abbfc6af4db8537fce8670c020f54feb18cf676c87cf144e49a4" => :el_capitan
    sha256 "0041fb06c97abc2bfaf7a0f375f7105534d026da2fed25ad3de27eba6a0d897f" => :x86_64_linux
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

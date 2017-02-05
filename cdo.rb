class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/12070/cdo-1.7.1.tar.gz"
  sha256 "5c24a5cb74dcf6e8b5140c67033868a5a0b641341e3adad3cb4035d5ad6e70a6"
  revision 4

  bottle do
    cellar :any
    sha256 "34b6bab80b77296be5b583b66fb94ebe94b36e3f8bfe0b1302eedf4d36fc62f3" => :sierra
    sha256 "7172e3de887cce4f042f07b65f2318945a4118b4b9a421c971097640ec5c5aee" => :el_capitan
    sha256 "f1ac9851bbc6e88818beb2e326af2c677dcb05a3d449bc00a9f57231c584a0a5" => :yosemite
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

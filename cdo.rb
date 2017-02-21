class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/12760/cdo-1.7.2.tar.gz"
  sha256 "4c43eba7a95f77457bfe0d30fb82382b3b5f2b0cf90aca6f0f0a008f6cc7e697"

  bottle do
    cellar :any
    sha256 "fb9fac6673c72b1c12d5f247520d8b809c09defc6f3d48dfb81fc3a94bbda3b8" => :sierra
    sha256 "1441c2453ea3e1f6d89740ed335055ba12c755e10475f8577060ac53d4e6a7b6" => :el_capitan
    sha256 "25774b4b8732029012f7ef7a98887b00df331ffa58393e2571d8990e5db2a1ca" => :yosemite
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

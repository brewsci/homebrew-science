class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/14271/cdo-1.8.1.tar.gz"
  sha256 "c3dd3a986c70e48b7b9cd9658de7794a96f85f25f7c68011fd175ce39abd7f93"
  revision 1

  bottle do
    cellar :any
    sha256 "a4da8a68c183682a708742e27c17293cdd27e952c4806d8bfaad0617845a413c" => :sierra
    sha256 "30a7b3e7dead3b924bd0fddd9760bbe8806843d01c7bc21b5e3d91f767da8fd1" => :el_capitan
    sha256 "64ea8eddfded59fea673626bbf1207ae0690866e9dd7bffe0f17e0dbe2209804" => :yosemite
    sha256 "bcb956938cb251aa130684e4e956f5fe758dcd03c0d87e5efec24acb67949cc4" => :x86_64_linux
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

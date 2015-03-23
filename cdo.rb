class Cdo < Formula
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/9444/cdo-1.6.7.tar.gz"
  sha256 "b7471dbe50d3726277ce30a92a429427158445e08bb90a8f9cb3aaa5b46f9e56"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "5eb3315c9fdf5fe36e9868326011f27cfd4f307a" => :yosemite
    sha1 "cab401ebf39e140b1cf33f804453a552b0d1504c" => :mavericks
    sha1 "e7580783a3b2c604e920db74ed0e51d0cd615d64" => :mountain_lion
  end

  option "with-grib2", "Compile Fortran bindings"
  deprecated_option "enable-grib2" => "with-grib2"

  if build.with? "grib2"
    depends_on "grib-api"
    depends_on "jasper"
  end

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

class Cdo < Formula
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/10198/cdo-1.6.9.tar.gz"
  sha256 "9970a7d5c29a59011fea8df6977e66b7d2a5d2dc8b0723a28ac0237d6e69dea8"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "0ecdd9d6614622ef3ce5b0c209d3641affbf58f2a093fb54efc4947a4c1a1a2e" => :yosemite
    sha256 "8e85667e942f3f4dcb32c5a951077c6954c9729c1a0de373db346d231748919d" => :mavericks
    sha256 "83e4fc8a3b07ff67be8f9ff4abd42dd2f3f481b3d565328c49a6c7cff8249c43" => :mountain_lion
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

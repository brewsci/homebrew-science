class Cdo < Formula
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.zmaw.de/attachments/download/9444/cdo-1.6.7.tar.gz"
  sha256 "b7471dbe50d3726277ce30a92a429427158445e08bb90a8f9cb3aaa5b46f9e56"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "c69849e24f64d430ec28232f6289ad76d94b05b0fdf013594943b62831d8a113" => :yosemite
    sha256 "bc3ee079e07bc8651ed819384ba435841d4b0aea7f5b7e413291cd8c6b6fe0b6" => :mavericks
    sha256 "469855d7fbe1e263724a1df292e662a31ecce6a0c984b6f5d34f00f36e15a013" => :mountain_lion
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

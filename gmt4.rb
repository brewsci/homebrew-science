class Gmt4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.16-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.16-src.tar.bz2"
  sha256 "4ef6a55605821c3569279a7088586dfdcf1e779dd01b4c957db096cc60fe959d"

  bottle do
    sha256 "f181b5b9a5c59f74cc8ac2e7ee9edbae78e3e129770cca9df377767500aa4e34" => :sierra
    sha256 "f889dabbefc98e010889ffbfa5889b14d61e72a66ad36e22c752da235f5a4893" => :el_capitan
    sha256 "8797c69f17e1d210deab9abb98020f40863d9ba4edc57d7925c4dc09c674ded0" => :yosemite
  end

  depends_on "gdal"
  depends_on "netcdf"

  conflicts_with "gmt", :because => "both versions install the same binaries."

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  def install
    ENV.deparallelize # Parallel builds don't work due to missing makefile dependencies
    datadir = share/name
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{datadir}",
                          "--enable-gdal=#{Formula["gdal"].opt_prefix}",
                          "--enable-netcdf=#{Formula["netcdf"].opt_prefix}",
                          "--enable-shared",
                          "--enable-triangle",
                          "--disable-xgrid",
                          "--disable-mex"
    system "make"
    system "make", "install-gmt"
    system "make", "install-data"
    system "make", "install-suppl"
    system "make", "install-man"
    datadir.install resource("gshhg")
  end

  test do
    cd testpath do
      system "gmt pscoast -R-90/-70/0/20 -JM6i -P -Ba5 -Gchocolate > GMT_tut_3.ps"
    end
  end
end

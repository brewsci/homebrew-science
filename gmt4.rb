require "formula"

class Gmt4 < Formula
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.12-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.12-src.tar.bz2"
  sha1 "a5ce7419a1aeb523540d2f93ca62153e47ce72fc"

  depends_on "gdal"
  depends_on "netcdf"

  conflicts_with "gmt", :because => "both versions install the same binaries."

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.1.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.1.tar.gz"
    sha1 "fe9e4e1c415faf09d51666e65c5b9d4b492c8a15"
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
    system "make install-gmt"
    system "make install-data"
    system "make install-suppl"
    system "make install-man"
    datadir.install resource("gshhg")
  end
end

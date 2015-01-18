require "formula"

class Gmt4 < Formula
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.13-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.13-src.tar.bz2"
  sha1 "b5086d17a231b7d7bacab1df3c4d4aa83714fe34"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "b6cf63cd2a789467ed7968ebb72a5c1f7124fda2" => :yosemite
    sha1 "15307b15fcb06b0b77513c1dcb0a0886045a1011" => :mavericks
    sha1 "f4ec0f3fd41e35de7e35f6c10eadd5d3a4835cac" => :mountain_lion
  end

  depends_on "gdal"
  depends_on "netcdf"

  conflicts_with "gmt", :because => "both versions install the same binaries."

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.4.tar.gz"
    sha1 "dc989e96a88533e7d44b788d1be8e0d7620f56d4"
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

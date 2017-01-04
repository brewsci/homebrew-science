class Gmt4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.15-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.15-src.tar.bz2"
  sha256 "f0646402858559ea07a3d51f5029a0b43e7af7547ab79c3064cce3f899ad6626"
  revision 1

  bottle do
    sha256 "80d171eace2444fe46dbd43b1c57c13a24494a7724ff8d1e19a380d25289dafd" => :sierra
    sha256 "4877dcfff9d20e30a1cedee8ee0a203c074ce18b6f5ce7da327502791fe1fdec" => :el_capitan
    sha256 "02902314093abd2bd3fec37cc3b0b2fba23908852bfa84fd005bf4188240940b" => :yosemite
  end

  depends_on "gdal"
  depends_on "netcdf"

  conflicts_with "gmt", :because => "both versions install the same binaries."

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.6.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.6.tar.gz"
    sha256 "ccffff9d96fd6c9cc4f9fbc897d7420c5fc3862fb98d1fd1b03dc4a15c95124e"
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

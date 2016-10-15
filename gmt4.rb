class Gmt4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.15-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.15-src.tar.bz2"
  sha256 "f0646402858559ea07a3d51f5029a0b43e7af7547ab79c3064cce3f899ad6626"

  bottle do
    sha256 "9941229dd9ec00eb4f81e044218d348cb96f7dd364a141f7ff3e1bad84beb988" => :el_capitan
    sha256 "b435bbc16bb61108fec57fde20c5c321f731deab4f6aa58f4428b08f94815bd8" => :yosemite
    sha256 "88327327631181c96c69a26e2cbd96bb36688ff33c76ebe23e182761d131d9c8" => :mavericks
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

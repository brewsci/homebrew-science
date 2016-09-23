class Gmt4 < Formula
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.14-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-4.5.14-src.tar.bz2"
  sha256 "b34ab9bcfdc6b85036546372f1c6ef6138420d12a343052fc95fed40962adfe3"

  bottle do
    sha256 "9941229dd9ec00eb4f81e044218d348cb96f7dd364a141f7ff3e1bad84beb988" => :el_capitan
    sha256 "b435bbc16bb61108fec57fde20c5c321f731deab4f6aa58f4428b08f94815bd8" => :yosemite
    sha256 "88327327631181c96c69a26e2cbd96bb36688ff33c76ebe23e182761d131d9c8" => :mavericks
  end

  depends_on "gdal"
  depends_on "netcdf"

  conflicts_with "gmt", because: "both versions install the same binaries."

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.4.tar.gz"
    sha256 "420c6c0df9170015ac0f7c7d472c5a58f8b70a7bf89f162c59dcd70735389110"
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

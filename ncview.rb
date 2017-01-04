class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 2

  bottle do
    sha256 "699f3ffdf7ffab5ce8f8f6eb47728af1a4584600b4b1641b975592b4364430ae" => :sierra
    sha256 "b51050ba2fda573b144999fc7eed547debaad78a73f867c951beb51abff59e17" => :el_capitan
    sha256 "623fb9f94303ec78c952461dd1498a1c43155c38f09cb5d486a7ee6ff2d2d11c" => :yosemite
  end

  depends_on :x11
  depends_on "netcdf"
  depends_on "udunits"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Ncview #{version}", pipe_output("#{bin}/ncview -c 2>&1")
  end
end

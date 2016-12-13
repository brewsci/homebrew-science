class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 1

  bottle do
    sha256 "5f34c0cf063d849c6234ce94574e91d1b53b5645904bd6872bc77b4ff1b0e4f1" => :el_capitan
    sha256 "4f31df722ff766d37db0b9e0ef09f5e6a01001f472088d9da4a56ee19c635190" => :yosemite
    sha256 "9ffb26848b261f24f7592eedab5f6c7e6512bb93360e74a4da65625c627a1a0b" => :mavericks
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

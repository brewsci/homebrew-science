class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 3

  bottle do
    sha256 "95451965c790c62b6a061f15adf3d9025a715f9c98bba2434f80cd7340c0cdf6" => :sierra
    sha256 "a11fcaa70d6f511a8654497880acdba0c29d69a6750b2b2bc4936cdad7b38d88" => :el_capitan
    sha256 "c55fc40eab252415d2d668e6363595967a0e867cfc60fd1556af82cdfa95abcd" => :yosemite
  end

  depends_on :x11
  depends_on "netcdf"
  depends_on "udunits"

  def install
    # put choice of compiler back in our hands
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if test x != x; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Ncview #{version}", pipe_output("#{bin}/ncview -c 2>&1")
  end
end

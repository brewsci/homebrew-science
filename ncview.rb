class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"
  revision 4

  bottle do
    sha256 "b92e78e1d9cedd16eaf1aa393b20d962faec9a7c5da21f38acbfc39c1e49af43" => :sierra
    sha256 "c49c2f89c2eff5e0d6a04a7f85bfc9f4fa1c8c206b1e6aafd68b75ee2bdb3b2e" => :el_capitan
    sha256 "5389ddaafe7a642c4d9a3fbfe78e788a69e2d29cb2fc3b3fff8769f28efd4c7d" => :yosemite
    sha256 "802f5b11496a4b5687ea95615ffa3ec4e883ea3c3f7e8215c2491f6f39c8ea80" => :x86_64_linux
  end

  depends_on :x11
  depends_on "netcdf"
  depends_on "udunits"
  depends_on "curl" unless OS.mac?

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

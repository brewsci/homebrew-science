class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"

  bottle do
    sha256 "8b3584cf81b5af815ac5b356c3ae1c8f46b7bffbfa0a4fb3507cb82249194bd3" => :el_capitan
    sha256 "acf3fa15854393999dd3b00a2253d1940957c32fff842cc619cefb172e844311" => :yosemite
    sha256 "2ad7d9a022a639febceb28b23476b7b1cec993f22987e425e178b0e450de19e5" => :mavericks
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
    assert_match /Ncview #{version} /, shell_output("#{bin}/ncview -c 2>&1")
  end
end

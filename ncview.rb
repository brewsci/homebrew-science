class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "http://meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz"
  mirror "https://fossies.org/linux/misc/ncview-2.1.7.tar.gz"
  sha256 "a14c2dddac0fc78dad9e4e7e35e2119562589738f4ded55ff6e0eca04d682c82"

  bottle do
    sha256 "ccda1abb486e34f024c7efeb98e13523f0687c207c04bb76203e859ac57a9014" => :el_capitan
    sha256 "a118ed4638dc2ca0ddab8391d16354335ba95f1f9bbbcbfca545552895d65ca6" => :yosemite
    sha256 "20642b877a84345f987ecd0cc62921e43ed2475f09db2d5c9cb604ca0399f1e3" => :mavericks
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

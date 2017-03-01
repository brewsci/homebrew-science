class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "https://nccmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.0.tar.gz"
  sha256 "7f5dad4e8670568a71f79d2bcebb08d95b875506d3d5faefafe1a8b3afa14f18"
  revision 3

  bottle do
    sha256 "26b99d3f807f4c86d7d29847d2e654d460243b80cf044f92e66128c29c7522ca" => :sierra
    sha256 "c9f673373e8886dbc99f0ae932b4f4e7ce2ebb1a1ef72364a46cd1a245208389" => :el_capitan
    sha256 "2f2eb6ec6298d0df12a4d3ca5338a6cf677644e6e1cceb084beafd865ef267b0" => :yosemite
    sha256 "54a4db6629830761389a30492628d5390acd90e0e5c2dba0318d4fb59d8241f7" => :x86_64_linux
  end

  depends_on "netcdf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cdl").write("netcdf {}")
    system "ncgen", "-o", testpath/"test1.nc", testpath/"test.cdl"
    system "ncgen", "-o", testpath/"test2.nc", testpath/"test.cdl"
    assert_equal `#{bin}/nccmp -mds #{testpath}/test1.nc #{testpath}/test2.nc`,
                 "Files \"#{testpath}/test1.nc\" and \"#{testpath}/test2.nc\" are identical.\n"
  end
end

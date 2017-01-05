class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.0.tar.gz"
  sha256 "7f5dad4e8670568a71f79d2bcebb08d95b875506d3d5faefafe1a8b3afa14f18"
  revision 1

  bottle do
    sha256 "da48d31b9afab5d9105ea8404354d89a3353d20f80f40d915e0185cba03343d0" => :sierra
    sha256 "557bca5b30058bb1c1beb8d2728ed67c89ae0ba66b425278ed9f0d6890406cde" => :el_capitan
    sha256 "71db607bfa55acc366f701c93a0eef7da9bba783562edd9a2ba279a722d2c50b" => :yosemite
    sha256 "23abd74e4ff06706bd993f270476ddb172ab6e6cf6bb5609db0143c86c6aba87" => :x86_64_linux
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

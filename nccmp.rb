class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.0.tar.gz"
  sha256 "7f5dad4e8670568a71f79d2bcebb08d95b875506d3d5faefafe1a8b3afa14f18"
  revision 3

  bottle do
    sha256 "d1dde0ba629c06c3094e5d7ef4a6664315e1e7fb949180d16ac55e7b6b21b67a" => :sierra
    sha256 "2b2728d28f2aa1c045ec9c3e3893af999177ce34ce8abdf62485703f18b36c35" => :el_capitan
    sha256 "8153f73249ae1cc36d4327e7379696a0b32bbd465ef124c465c26d7dddb2485f" => :yosemite
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

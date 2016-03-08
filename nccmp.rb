class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.0.tar.gz"
  sha256 "7f5dad4e8670568a71f79d2bcebb08d95b875506d3d5faefafe1a8b3afa14f18"

  bottle do
    sha256 "1528f282673ba7ce6d7f6466b2f26252fb93c31eb8ed608e434ccbc78cd54557" => :el_capitan
    sha256 "0b21b5c2c55d8ca6781dc83044f6878342bb354e99014cd77c5666a61a940d46" => :yosemite
    sha256 "867dc0ab6af3c2a2b9be6174aee021aefc2a4d0fe7dd1a73cf08734083facea1" => :mavericks
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

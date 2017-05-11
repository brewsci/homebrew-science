class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "https://nccmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.0.tar.gz"
  sha256 "7f5dad4e8670568a71f79d2bcebb08d95b875506d3d5faefafe1a8b3afa14f18"
  revision 4

  bottle do
    sha256 "3ffbd2f51e9af9bb5ac351f8c1bdbb77bd5314ac86a15744806e0c3567a3e754" => :sierra
    sha256 "1150fd5daeeca93bd19ba0d9f675b840cbceee7e06289b01ae9cbb6b356401e2" => :el_capitan
    sha256 "05180490d4f52a5ba395fbe1638783859755f445f4c8ceadae62dd8ec63aa98a" => :yosemite
    sha256 "a192c3521fccbe56e446e9be36eb4ef6622906c203ce3a80d74ad69c5aa799b8" => :x86_64_linux
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

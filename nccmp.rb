class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "https://nccmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.1.tar.gz"
  sha256 "5bbde05f402aa909480436247165eb0c3681bc53e931b6342af808fd59636c8b"

  depends_on "netcdf"

  def install
    chmod 0555, "install-sh"

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

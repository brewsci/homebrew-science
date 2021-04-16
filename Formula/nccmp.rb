class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance"
  homepage "https://nccmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.2.1.tar.gz"
  sha256 "5bbde05f402aa909480436247165eb0c3681bc53e931b6342af808fd59636c8b"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 high_sierra:  "ff42c7a848d0c4a672ccee9cd39a5b337160c1f44ae8d5e097a4c0027dad9aca"
    sha256 sierra:       "30481fe58855ffd99b4448474338540a87368eb6017ade6adf36ecb49c5177ba"
    sha256 el_capitan:   "47e04c0afd5d78ae2c6758edf7f460b85805fdf510c3d701d17b350fd6c7a123"
    sha256 x86_64_linux: "5e7567c24e03cb465c9af9fea0499f5a939115126d5b5b227e8e025a043737d5"
  end

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

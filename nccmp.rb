class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.0.0.tar.gz"
  sha256 "dd64bb0d66a1c3f358308b0d10e2881605b3391df285e3322cca0e578c8e2129"

  bottle do
    sha256 "f5b81ff204e0538b3c1f8e37c9fa9cd41e6b2a56a39149221298f5e33f45be0e" => :el_capitan
    sha256 "46db69eb61b228b39c2e6e12d89f981dd97ad61af03a5ba1cc54d23c9f25262d" => :yosemite
    sha256 "199f6357684f35cf277a835c5963c3579ae300e07555603ebe32ff580c3e3894" => :mavericks
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

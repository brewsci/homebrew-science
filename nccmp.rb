class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance."
  homepage "http://nccmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nccmp/nccmp-1.8.0.0.tar.gz"
  sha256 "dd64bb0d66a1c3f358308b0d10e2881605b3391df285e3322cca0e578c8e2129"

  bottle do
    sha256 "df6a1535cb263beb12ef7f5294676f91d3ae4ab11fdbb463be4935f161abf058" => :el_capitan
    sha256 "ad375aa6c2ea7676504a67234fe442ba5df3c8d587e81344c39c9a4d295cf1f9" => :yosemite
    sha256 "219d5c64e43958356b65c7ece4650800dc61f86eb9eb8a99dfa83a68c81252ae" => :mavericks
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

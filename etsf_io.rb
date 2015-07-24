class EtsfIo < Formula
  homepage "http://www.etsf.eu/resources/software/libraries_and_tools"
  url "http://www.etsf.eu/system/files/etsf_io-1.0.4.tar.gz"
  sha256 "3140c2cde17f578a0e6b63acb27a5f6e9352257a1371a17b9c15c3d0ef078fa4"
  revision 2

  bottle do
    sha256 "cd03510221814aef2f3d0e2039e42c31b41ee9735fd271a04d883c94dc73a694" => :yosemite
    sha256 "a1a3888da1bbbb4f808768413f57267ddd90f97111992e4d9f161a494a51728a" => :mavericks
    sha256 "2ccb27658150b9cf718d4e297e6b74e9f70516fed326d27694e15c68680d077c" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "netcdf" => ["with-fortran"]

  def install
    system "./configure", "--prefix=#{prefix}", "--with-moduledir=#{include}",
           "--with-netcdf-incs=-I#{Formula["netcdf"].opt_include}",
           "--with-netcdf-libs=-L#{Formula["netcdf"].opt_lib} -lnetcdff -lnetcdf"

    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/etsf_io", "--help"
  end
end

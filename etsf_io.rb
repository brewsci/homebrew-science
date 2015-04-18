class EtsfIo < Formula
  homepage "http://www.etsf.eu/resources/software/libraries_and_tools"
  url "http://www.etsf.eu/system/files/etsf_io-1.0.4.tar.gz"
  sha256 "3140c2cde17f578a0e6b63acb27a5f6e9352257a1371a17b9c15c3d0ef078fa4"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "e0499a8beae7e9dbad907e794610213342891cf6e24adc018da926518a20ca96" => :yosemite
    sha256 "55adbf17bd8d8ccaa43215b3ab7628a01116e286fba64d09b3ee9b3d50dab077" => :mavericks
    sha256 "38faa1e76b2f6d72fe29ae0c1753f607dd9cb7aa0b7d8e318ba7580a31c53089" => :mountain_lion
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

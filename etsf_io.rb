class EtsfIo < Formula
  desc "Library of F90 routines to read and write the ETSF file format"
  homepage "http://www.etsf.eu/resources/software/libraries_and_tools"
  url "http://www.etsf.eu/system/files/etsf_io-1.0.4.tar.gz"
  sha256 "3140c2cde17f578a0e6b63acb27a5f6e9352257a1371a17b9c15c3d0ef078fa4"
  revision 5
  # doi "10.1016/j.cpc.2008.05.007"

  bottle do
    sha256 "f98947cd96f7464bd2c3ae0490865780624267f39ffad7b8a7c8bdb53be84c23" => :sierra
    sha256 "9bd2d3b7c0249842fde7326f1c73cd3b33244d28d497905fceaf94e2e1813db5" => :el_capitan
    sha256 "ae10fdb25a3b95f7870e20e65a8efcb90888d70b67745b2a56b6cb5ed128029e" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  if OS.mac?
    depends_on "gcc@5"
  else
    depends_on :fortran
  end
  depends_on "netcdf" => "with-fortran"

  def install
    ENV["FC"] = Formula["gcc@5"].opt_bin/"gfortran-5" if OS.mac?

    system "./configure", "--prefix=#{prefix}", "--with-moduledir=#{include}",
           "--with-netcdf-incs=-I#{Formula["netcdf"].opt_include}",
           "--with-netcdf-libs=-L#{Formula["netcdf"].opt_lib} -lnetcdff -lnetcdf"

    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/etsf_io", "--help"
  end
end

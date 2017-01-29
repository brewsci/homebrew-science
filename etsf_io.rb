class EtsfIo < Formula
  desc "Library of F90 routines to read and write the ETSF file format"
  homepage "http://www.etsf.eu/resources/software/libraries_and_tools"
  url "http://www.etsf.eu/system/files/etsf_io-1.0.4.tar.gz"
  sha256 "3140c2cde17f578a0e6b63acb27a5f6e9352257a1371a17b9c15c3d0ef078fa4"
  revision 4
  # doi "10.1016/j.cpc.2008.05.007"

  bottle do
    sha256 "8c1b67b178286f5e780c07f170593a6036dddf1733771a4ce72d94c437c123ef" => :el_capitan
    sha256 "f0115fa7db2c4d5a27afaa8c7e6db275b3aa1dd143baf62df48984cc34e0e315" => :yosemite
    sha256 "3e35f91bf47ee55f0b9a7b5e394942a264d5dd3e5e8edf03aaa8ccc8dba66434" => :mavericks
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

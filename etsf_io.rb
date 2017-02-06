class EtsfIo < Formula
  desc "Library of F90 routines to read and write the ETSF file format"
  homepage "http://www.etsf.eu/resources/software/libraries_and_tools"
  url "http://www.etsf.eu/system/files/etsf_io-1.0.4.tar.gz"
  sha256 "3140c2cde17f578a0e6b63acb27a5f6e9352257a1371a17b9c15c3d0ef078fa4"
  revision 4
  # doi "10.1016/j.cpc.2008.05.007"

  bottle do
    sha256 "e62f892c31970d03b4cc44739e7bd85a253436cc2f39fb6a7c27e9d3f0f32fff" => :sierra
    sha256 "1ceea6758e69576bee533d43ca3637e53164c8d7acb8cc44a4c13ca7d6fea225" => :el_capitan
    sha256 "eb5dcfe3b05474ee21edc23882d7aa524a9dda0d9ed15108a5ebc4106c9c92e6" => :yosemite
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

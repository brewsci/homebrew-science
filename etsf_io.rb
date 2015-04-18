class EtsfIo < Formula
  homepage "http://www.etsf.eu/resources/software/libraries_and_tools"
  url "http://www.etsf.eu/system/files/etsf_io-1.0.4.tar.gz"
  sha256 "3140c2cde17f578a0e6b63acb27a5f6e9352257a1371a17b9c15c3d0ef078fa4"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "e7fe29cf45a970f5213f3f8cfc17afdb895b40f3374dfed476462b10041650c0" => :yosemite
    sha256 "fdd49e9bb444e7493779a44e9e738dd7d14374101b81c3305de1e6cd91798afb" => :mavericks
    sha256 "faa24b48cc02b28542777c35113421953227bfae1fa1da70aebf57819b7bf841" => :mountain_lion
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

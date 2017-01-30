class Mbsystem < Formula
  desc "MB-System seafloor mapping software"
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/mbsystem/mbsystem-5.5.2284.tar.gz"
  sha256 "62afc8bf4313720af48caa0c11d7596c4fce263420653fce90b600e99c23e709"
  revision 2

  bottle do
    sha256 "656404da7e5e7e029b34634fbbfbe3dbbe7cd7bf6b38bdfa14caee5aa3fc6a26" => :sierra
    sha256 "68f565c89ff7657153a1e7cac9644290e5ae2465f26de2b14fbad7189031f0e6" => :el_capitan
    sha256 "a92bc9c96c606a39c88395d0fec54a4a92153d866e6b435dd34029bd6320502c" => :yosemite
  end

  option "without-levitus", "Don't install Levitus database (no mblevitus)"
  option "without-test", "Disable build time checks (not recommended)"
  depends_on :x11
  depends_on "gmt"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "fftw"
  depends_on "gdal"
  depends_on "gv"
  depends_on "openmotif"

  resource "levitus" do
    url "ftp://ftp.ldeo.columbia.edu/pub/MB-System/annual.gz"
    sha256 "0b57ce813259843ca0b141e2a34a001bc5ebb53b24020a891d0715b9282ebeac"
  end

  def install
    if build.with? "levitus"
      resource("levitus").stage do
        mkdir_p "#{pkgshare}/mbsystem"
        ln_s "annual", "#{pkgshare}/mbsystem/LevitusAnnual82.dat"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared",
                          "--with-gmt-include=#{Formula["gmt"].opt_include}/gmt",
                          "--with-gmt-lib=#{Formula["gmt"].opt_lib}/gmt"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

class Mbsystem < Formula
  desc "MB-System seafloor mapping software"
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/mbsystem/mbsystem-5.5.2284.tar.gz"
  sha256 "62afc8bf4313720af48caa0c11d7596c4fce263420653fce90b600e99c23e709"
  revision 4

  bottle do
    sha256 "88ac96da4995d9033b32b4df6582e42e3c934797a4679358af2fe9f6ab8db983" => :sierra
    sha256 "f81cb296dab4edc9648c0c627991dc9069f28d3fc5e75cc85f496514a29f337a" => :el_capitan
    sha256 "aa271c8ca180de1c7b9ee880b01de8a46068e9530d31dae529538a7f9b2d4ee5" => :yosemite
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

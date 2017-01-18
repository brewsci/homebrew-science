class Mbsystem < Formula
  desc "MB-System seafloor mapping software"
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/mbsystem/mbsystem-5.5.2284.tar.gz"
  sha256 "62afc8bf4313720af48caa0c11d7596c4fce263420653fce90b600e99c23e709"

  bottle do
    sha256 "e12ead181c837c4524f6d6fed2948ffe35a37bb00329addc903b670efd744253" => :sierra
    sha256 "3fa492521e91c227d87c0dd98d42b44bb8862c50bf998533066510a3d1ba8ce6" => :el_capitan
    sha256 "9e8ce30fbfba06ea3c9b96f894dbe14cc12e6a1461cf5b2544742e0583a99d65" => :yosemite
  end

  option "without-levitus", "Don't install Levitus database (no mblevitus)"
  option "without-test", "Disable build time checks (not recommended)"
  depends_on :x11
  depends_on "gmt"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "fftw"
  depends_on "gdal"
  depends_on "homebrew/x11/gv"
  depends_on "homebrew/x11/openmotif"

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

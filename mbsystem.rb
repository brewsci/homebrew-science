require "formula"

class Mbsystem < Formula
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/MB-System/mbsystem-5.4.2209.tar.gz"
  sha1 "e36e28ceefe7514df8bf2b5ead57c7e028e8f9dd"

  depends_on :x11
  depends_on "gmt4"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "fftw"
  depends_on "gv"
  depends_on "lesstif"

  option "without-levitus", "Don't install Levitus database (no mblevitus)"
  option "without-check", "Disable build time checks (not recommended)"

  resource "levitus" do
    url "ftp://ftp.ldeo.columbia.edu/pub/MB-System/annual.gz"
    sha1 "2dd876e3d4a56ac6502f7ff92156f072e54183e7"
  end

  def install
    if build.with? "levitus"
      resource("levitus").stage do
        mkdir_p "#{share}/mbsystem"
        ln_s "annual", "#{share}/mbsystem/LevitusAnnual82.dat"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

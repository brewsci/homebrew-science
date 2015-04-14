class Mbsystem < Formula
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/MB-System/mbsystem-5.5.2233.tar.gz"
  sha256 "13693a326cd44aa25ec5a0a69a5ffca4d47e3a529c0cc0abaf83165c8adf6958"

  depends_on :x11
  depends_on "gmt"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "fftw"
  depends_on "gv"
  depends_on "lesstif"

  option "without-levitus", "Don't install Levitus database (no mblevitus)"
  option "without-check", "Disable build time checks (not recommended)"

  resource "levitus" do
    url "ftp://ftp.ldeo.columbia.edu/pub/MB-System/annual.gz"
    sha256 "0b57ce813259843ca0b141e2a34a001bc5ebb53b24020a891d0715b9282ebeac"
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
                          "--enable-shared",
                          "--with-gmt-include=#{Formula["gmt"].opt_include}/gmt",
                          "--with-gmt-lib=#{Formula["gmt"].opt_lib}/gmt"#,
                          #"--with-otps-dir=<path-to-OTPS>"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

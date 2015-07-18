class Mbsystem < Formula
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/mbsystem/mbsystem-5.5.2252.tar.gz"
  sha256 "ad27595c93562e34ff4d973259e0379edcfbf74bc5ef5a5103a2f75d96809f7d"

  bottle do
    sha256 "a7b29a93c1f6fdcf03aa220fbbfb4ae2371718dc4744553ef5584be4289d16a6" => :yosemite
    sha256 "ebfe7096b38889c65e6d75e279d5caf724e7890639e80f195f95071951bef927" => :mavericks
    sha256 "5c47f7b604b7bb91cc37ef61f05f1526a878214d2962e41ad0a51cd39f9e9403" => :mountain_lion
  end

  depends_on :x11
  depends_on "gmt"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "fftw"
  depends_on "homebrew/x11/gv"
  depends_on "homebrew/x11/openmotif"

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
                          "--with-gmt-lib=#{Formula["gmt"].opt_lib}/gmt"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

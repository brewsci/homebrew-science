class Mbsystem < Formula
  desc "MB-System seafloor mapping software"
  homepage "http://www.mbari.org/data/mbsystem/mb-cookbook/index.html"
  url "ftp://ftp.ldeo.columbia.edu/pub/mbsystem/mbsystem-5.5.2279.tar.gz"
  sha256 "50b0013af2bb2d66d8278057f64ea3d3be931d23e6fb7aa0af207285b27c00f2"

  bottle do
    sha256 "6f8bff9625cc43d4f85b29dd52ae469d666f23bcb2d77ebda27241eff56a9f31" => :sierra
    sha256 "2888a337d7e0410a8cb67b424e449bc40c4b24e19663594e9af41043170b2680" => :el_capitan
    sha256 "fcaab8cd709d6b58b6a2571bb62bd0e4694cdc494741d3ba60f6b2128487c74c" => :yosemite
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

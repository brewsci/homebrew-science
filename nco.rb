class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.5.tar.gz"
  sha256 "d5b18c9ada25d062a539e2995be445db39e8021c56cd4b20c88485cb2452c7ae"

  bottle do
    cellar :any
    sha256 "0dd5c758b23db908526f1dddcf1b30e55c166d2a902238a8040824a9f5ed59b3" => :sierra
    sha256 "b24a27b208166678cd145b74d1acd9517dedf40a28337c2f50e315d2696cc31a" => :el_capitan
    sha256 "51feb2309b86020b366fadb9d825e5fc2ac383a175a26ed788821794dda6778d" => :yosemite
  end

  head do
    url "https://github.com/czender/nco.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  # NCO requires the C++ interface in Antlr2.
  depends_on "antlr@2"

  def install
    system "./autogen.sh" if build.head?
    inreplace "configure" do |s|
      # The Antlr 2.x program installed by Homebrew is called antlr2
      s.gsub! "for ac_prog in runantlr antlr", "for ac_prog in runantlr antlr2"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    system bin/"ncap", "--help"
  end
end

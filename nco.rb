class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.7.tar.gz"
  sha256 "6b9297093e38e29a7b44f263f67aa0e728052d947338bbb1f6fc2a4cc4b910c6"

  bottle do
    cellar :any
    sha256 "954d4defc325c7b0bf0a3107625315c5e422059138a9e8b2f5c60e10be189af3" => :sierra
    sha256 "632d6d3348374e261026870f52f0f0a9464401131ba680c7f7e6045be694b782" => :el_capitan
    sha256 "8ce177823a0da5093d13e343c770198daac332f3b542578f009e2318a7b6c8c0" => :yosemite
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

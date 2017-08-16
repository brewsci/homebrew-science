class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.8.tar.gz"
  sha256 "d818a9e4026d5cc5b4372a212ef3385449a757ee00b807ae9b91741bc79a545b"

  bottle do
    cellar :any
    sha256 "e8712d2be6bceea8117ed31a8660367b64ee25ba923268362a4069b317a61a6e" => :sierra
    sha256 "a1b690e098199e216614c6d57d181afaf0c94d2291875ad2191f7dc18521f5ca" => :el_capitan
    sha256 "9ae3f86055d03dc6fd13191f7a9fca303248ed5fd8f1b6e91f112dce301a4fb0" => :yosemite
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

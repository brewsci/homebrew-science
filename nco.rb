class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nco/nco_4.6.1.orig.tar.gz"
  sha256 "7433fe5901f48eb5170f24c6d53b484161e1c63884d9350600070573baf8b8b0"
  revision 1

  bottle do
    cellar :any
    sha256 "2261855bded863b34e7318894319bcc029f2592288b0c2102a8a60873d5ecd06" => :el_capitan
    sha256 "fff806f79884e2acce0e0e6ce497ac8b16d0296015ae15511951df8f063fb628" => :yosemite
    sha256 "093e3088df1eff83b22311e96713ac1cbf429a2606067532acd1b7a61e4f0341" => :mavericks
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
  depends_on "homebrew/versions/antlr2"

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

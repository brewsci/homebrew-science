class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.7.tar.gz"
  sha256 "2fe2dabf14a60bface694307cbe719df57103682b715348e9d77bfe8d31487f3"
  revision 1

  bottle do
    cellar :any
    sha256 "9426e908b57cdd133ffe60ae4ce12422a3652dd252095fe323451e65ddbd3f20" => :sierra
    sha256 "1094c15b24fb81f9eecf89e70e55a565ecac7e40e8f0102c8be9df5f0b85144b" => :el_capitan
    sha256 "30406771f389b19130678161845b5c4c10c67d2809247aadc1bdd23f51cac390" => :yosemite
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

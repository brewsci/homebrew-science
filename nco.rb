class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.4.tar.gz"
  sha256 "1c2ab906fc81f91bf8aff3e6da27ae7a4c89821c5836d787188fff5262418062"

  bottle do
    cellar :any
    sha256 "4e072f323acd46c967f0c1017f4a33fbf630bc414d4ea93e1ae759046be6c478" => :sierra
    sha256 "3259affb4651da6ba0f757b3abc3d08ce7d329c698589e5b789cb01f769a5a35" => :el_capitan
    sha256 "5ec26e95c327c5db650683342bd9f5a438b82ca90373a7b011e3440bbf65de31" => :yosemite
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

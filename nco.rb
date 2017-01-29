class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.2.tar.gz"
  sha256 "cec82e35d47a6bbf8ab9301d5ff4cf08051f489b49e8529ebf780380f2c21ed3"
  revision 2

  bottle do
    cellar :any
    sha256 "3fddb0722ea091c93c6efcce5dadb65360f43b5695a251ff1ff2f70690c1a4ce" => :sierra
    sha256 "b5ca62168e0cf92d4014aa136551301deee01352fe8b496383e08561d1529403" => :el_capitan
    sha256 "1f2a40d7753c4a6f35e8f368001330781177e934148df1c5ad6a616474302100" => :yosemite
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

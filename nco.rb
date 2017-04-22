class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.6.tar.gz"
  sha256 "079d83f800b73d9b12b8de1634a88c2cbe40a639aaf7bc056cd2e836c6047697"

  bottle do
    cellar :any
    sha256 "bbf8bcff55db64fe66957fd7ff48fe68aee05ff28592e6a4dfcc39d999a6c7ce" => :sierra
    sha256 "9776c52effbf5af9c0f365624ce8a4ddc5c7608df0ffc7e27397787f67328854" => :el_capitan
    sha256 "432bd72c133cb53236eb8917974b5735f268cebc1c6973567d1dc4bee721c83a" => :yosemite
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

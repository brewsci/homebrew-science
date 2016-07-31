class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nco/nco_4.6.0.orig.tar.gz"
  sha256 "2ebeec6456255d363e9f5ef92d45cd809c058495d2c3920de3eacda5098986a9"

  bottle do
    cellar :any
    sha256 "149711db327862ee54ac2746f70574ac825dd25a8a0a406d99a1b3ebe1132b01" => :yosemite
    sha256 "c20f5aed3a1975e73fab0fa04c55f7d6b01e31c78df56ffb0da7727317e5ba10" => :mavericks
    sha256 "39507a6ef69f69038a336ddc8422faa92131a7420af4477b715463cbe5c4a67a" => :mountain_lion
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

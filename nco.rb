class Nco < Formula
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.4.8.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nco/nco_4.4.8.orig.tar.gz"
  sha256 "974dea6ac11d8b265e8dd5b29376fede5ea76a50dc06afb4d5de49d7e8d48774"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "149711db327862ee54ac2746f70574ac825dd25a8a0a406d99a1b3ebe1132b01" => :yosemite
    sha256 "c20f5aed3a1975e73fab0fa04c55f7d6b01e31c78df56ffb0da7727317e5ba10" => :mavericks
    sha256 "39507a6ef69f69038a336ddc8422faa92131a7420af4477b715463cbe5c4a67a" => :mountain_lion
  end

  devel do
    url "https://github.com/czender/nco/archive/nco-4.4.9-alpha.tar.gz"
    sha256 "bebd22d810b9a58e3a148fe316929c238403c6352b77f3ea9757662222540204"
    version "4.4.9-alpha"
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

class Nco < Formula
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.4.8.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nco/nco_4.4.8.orig.tar.gz"
  sha256 "974dea6ac11d8b265e8dd5b29376fede5ea76a50dc06afb4d5de49d7e8d48774"

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

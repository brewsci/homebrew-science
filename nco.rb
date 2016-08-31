class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nco/nco_4.6.1.orig.tar.gz"
  sha256 "7433fe5901f48eb5170f24c6d53b484161e1c63884d9350600070573baf8b8b0"
  revision 1

  bottle do
    cellar :any
    sha256 "eb3ce36064e14f66d75cb70cfd0af365d0ef6585038a471f7c67f43b8a5f12fc" => :el_capitan
    sha256 "59743fc5351a1e8808df227a795b0926507421f1298a8ffc8e245aa8f0f63f8b" => :yosemite
    sha256 "ae64fb0640e89d2521ee234f4b66eb660a546d6c25e1991c45ad4d41cf978b4b" => :mavericks
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

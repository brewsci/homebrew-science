class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nco/nco_4.6.0.orig.tar.gz"
  sha256 "2ebeec6456255d363e9f5ef92d45cd809c058495d2c3920de3eacda5098986a9"

  bottle do
    cellar :any
    sha256 "eb48f1982386af5287db2fc61245fea61c799cb1a1b26ddcd468dc79d84f8031" => :el_capitan
    sha256 "a000ec79262a2421fc2cbd06c71656a30e25243f1ff89b147340187b4f75c4dc" => :yosemite
    sha256 "b31d5d66e9885d6c20628973aeb5493400e87e4c9982f8b11a434c48bcb63611" => :mavericks
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

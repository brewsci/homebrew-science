class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "http://nco.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.4.tar.gz"
  sha256 "1c2ab906fc81f91bf8aff3e6da27ae7a4c89821c5836d787188fff5262418062"

  bottle do
    cellar :any
    sha256 "99ee3ee57f994623986b957063b3ff3faad095ac12b9827957f6da63ad68bf50" => :sierra
    sha256 "86b1008be45d9e940e3544ab667469e69eb8023e863737f211828ac504def99a" => :el_capitan
    sha256 "859a343b40d8099a5996b3db4d5b811e502fa1e2261f5a6a6f30a395cc67c948" => :yosemite
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

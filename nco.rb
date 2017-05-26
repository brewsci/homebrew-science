class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.6.7.tar.gz"
  sha256 "6b9297093e38e29a7b44f263f67aa0e728052d947338bbb1f6fc2a4cc4b910c6"

  bottle do
    cellar :any
    sha256 "029dd5b441c238fd2fe96375d8056230d45b686bca5d569ac577c97cce029f83" => :sierra
    sha256 "2165ce4cd33e02b31990cc7f3a78f1d7461ca44ce2f7b2536ae3e69ab17e829d" => :el_capitan
    sha256 "18c5421d70d12619ea8f86920ab720f153d85265f56593edf72dc0c63d393fae" => :yosemite
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

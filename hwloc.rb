class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "http://www.open-mpi.org/projects/hwloc/"
  url "http://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.4.tar.bz2"
  sha256 "fdc59d06c1ddedb0fa41039bb84cb406f0570b6e66223c13a60077831d36e038"

  bottle do
    cellar :any
    sha256 "8df975fd83e75442392f6822cb80a3a61d3b85c250e53ca19cf24d40e625bf21" => :el_capitan
    sha256 "2c2b7d3c47b372ef1e849aa53d628cb8110a983c7667ff248c91e1ab45287075" => :yosemite
    sha256 "d87e0c400c344cf0e5013ff739ad0676c63ad4dc6a17f566554761430cc965fc" => :mavericks
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cairo" => :optional

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lhwloc",
           pkgshare/"tests/hwloc_groups.c", "-o", "test"
    system "./test"
  end
end

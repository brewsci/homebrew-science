class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "http://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.6.tar.bz2"
  sha256 "7685f7b96c7c79412c494633862612b36f8745f05f84d35ab495d38b456d87fa"

  bottle do
    cellar :any
    sha256 "4fd02c988d1fc3610aa947d6d9b254466d2bc0de4f421955ae3c6d42bb47e04a" => :sierra
    sha256 "850dc5ef20b1d125e9d638c18aefea92ffb19555f8cb799905fbcd6ee8b846d8" => :el_capitan
    sha256 "7785fcf539260dd3530ade28c851478827f73cc7ae359a430dc647062b3ca947" => :yosemite
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo" => :optional

  def install
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

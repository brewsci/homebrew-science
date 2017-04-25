class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.6.tar.bz2"
  sha256 "7685f7b96c7c79412c494633862612b36f8745f05f84d35ab495d38b456d87fa"
  revision 1

  bottle do
    cellar :any
    sha256 "32d6b27303df7f7d251550832081f00f20f1876574ef60ae76a0a12c7c426e3d" => :sierra
    sha256 "715dfcb8a7e119827e4e32c1bd1b2763dfc6dbbeeef0a069a9faa611510a10ea" => :el_capitan
    sha256 "dff5f6a27353cc5d5ad3f443acdd907fa969bc0e846e0d68311287b242847335" => :yosemite
    sha256 "66b07c8f679c27453e0be3be230f21245ae9ecef9596cfa1a130066c5b4fd72b" => :x86_64_linux
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
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"
  end

  test do
    system ENV.cc, "-I#{include}",
      pkgshare/"tests/hwloc_groups.c",
      "-L#{lib}", "-lhwloc",
      "-o", "test"
    system "./test"
  end
end

class Hwloc < Formula
  homepage "http://www.open-mpi.org/projects/hwloc/"
  url "http://www.open-mpi.org/software/hwloc/v1.10/downloads/hwloc-1.10.1.tar.bz2"
  sha256 "35ce13a9a0737d2de1c6facb5c3c0438f7c83b45d6ce652e05ba000f6f2e514a"

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
                          "--prefix=#{prefix}"
    system "make", "install"

    share.install "tests"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lhwloc",
           share/"tests/hwloc_groups.c", "-o", "test"
    system "./test"
  end
end

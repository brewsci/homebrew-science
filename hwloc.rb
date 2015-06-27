class Hwloc < Formula
  homepage "http://www.open-mpi.org/projects/hwloc/"
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  url "http://www.open-mpi.org/software/hwloc/v1.10/downloads/hwloc-1.10.1.tar.bz2"
  sha256 "35ce13a9a0737d2de1c6facb5c3c0438f7c83b45d6ce652e05ba000f6f2e514a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "844537fd62745f1e45470609fdd8e896304844437ff15db68155927f92f79fe9" => :yosemite
    sha256 "ab65a49d5f4c421894af46a066166275064632400f005da426fc48e4520d4284" => :mavericks
    sha256 "76c5d075c3297b770a8270f899851c771db785d4b9a8c7cd7f1bad1269fa7199" => :mountain_lion
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
                          "--prefix=#{prefix}"
    system "make", "install"

    (share/"hwloc").install "tests"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lhwloc",
           share/"hwloc/tests/hwloc_groups.c", "-o", "test"
    system "./test"
  end
end

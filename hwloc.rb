class Hwloc < Formula
  homepage "http://www.open-mpi.org/projects/hwloc/"
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  url "http://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.0.tar.bz2"
  sha256 "9740f401b564b608c26b21cd06cf30157f0fdd731b0b264db6e8e2d47c4b3721"

  bottle do
    revision 1
    sha256 "2314fd97617643387585b8ee4bdf85a3320466ab3037f6c550b04dbe07640e8f" => :yosemite
    sha256 "76e34bac6990a4caaf56c8eddf595573c9128ec6071d5c4fdabb74a8bf5d35ba" => :mavericks
    sha256 "d940c936bf0da987756ff3b01f425f5bce06718e2ea8aba28d865e44ebad7617" => :mountain_lion
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

    pkgshare.install "tests"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lhwloc",
           share/"hwloc/tests/hwloc_groups.c", "-o", "test"
    system "./test"
  end
end

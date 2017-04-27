class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.7.tar.bz2"
  sha256 "ab6910e248eed8c85d08b529917a6aae706b32b346e886ba830895e36a809729"

  bottle do
    cellar :any
    sha256 "b40ea609b084b1afbd13a62d2be5b6e55173c0958ccfaa0788687f735fc06418" => :sierra
    sha256 "0e2695dc46cafcb6ec07aa131268dbf1cab2d75c6e11de33124650cf27ec989f" => :el_capitan
    sha256 "6e0e429821d181cc6212ed6bbfb3235c6af97b47346b6983cc22bb954cb3725e" => :yosemite
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

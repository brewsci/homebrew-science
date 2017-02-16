class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "http://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.5.tar.bz2"
  sha256 "95d80286dfe658a3f79e2ac90698782bb36e5504f4bac1bba2394ba14dbbad24"

  bottle do
    cellar :any
    sha256 "5461ef30286a4bc07a4fe67d25ff55fd580c2308ea03bbd2e9ea033033348bb7" => :sierra
    sha256 "61461d1dcbaf9fb98e10b993bc5f00df4e3d831c4a8509711444305791f8729b" => :el_capitan
    sha256 "9e79db5514219186cb948214b594a4ab8456ea26f52ca5ded8e453a2cb92b1a3" => :yosemite
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

class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "http://www.open-mpi.org/projects/hwloc/"
  url "http://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.4.tar.bz2"
  sha256 "fdc59d06c1ddedb0fa41039bb84cb406f0570b6e66223c13a60077831d36e038"

  bottle do
    cellar :any
    sha256 "685e2e21f9d2986dd89357f2a88dd1c24f6b7e32eda6a6cb3ac3731f54d6c02d" => :el_capitan
    sha256 "3f2d02f88cfb12df97056c0a2ca1567feaecf987bba16b34001c51a50002dc1f" => :yosemite
    sha256 "177c80b79f094ec60b6ea0e0e35f86fbb90b49a32b0772aec92f5e0edce8c8a4" => :mavericks
    sha256 "91737b14f08b8307397791536f0082fd6960d03637e825bd319c521ceb2504c1" => :x86_64_linux
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

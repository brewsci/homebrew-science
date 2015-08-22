class Hwloc < Formula
  homepage "http://www.open-mpi.org/projects/hwloc/"
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  url "http://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.0.tar.bz2"
  sha256 "9740f401b564b608c26b21cd06cf30157f0fdd731b0b264db6e8e2d47c4b3721"

  bottle do
    cellar :any
    sha256 "5b11efcb125cf9cceb3a0d2cd5eadd5ce53007f2d86c60c2915830c408a6ec5c" => :yosemite
    sha256 "8903789215d14430c0ae7e1cad0815491f027767bd6a5cac0ba635105a1b1bc4" => :mavericks
    sha256 "c3b52dd0b2cca4e88f03fd9e33d09500e969baa6f32e9fe98ea045c939ebe8a5" => :mountain_lion
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

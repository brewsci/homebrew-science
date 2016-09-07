class Xrmc < Formula
  desc "Monte Carlo simulation of X-ray imaging and spectroscopy experiments"
  homepage "https://github.com/golosio/xrmc"
  url "http://lvserver.ugent.be/xrmc/files/xrmc-6.5.0.tar.gz"
  mirror "https://xrmc.s3.amazonaws.com/xrmc-6.5.0.tar.gz"
  sha256 "4995eaaf3b4583d443d0cf2003d73d1855b443938e431a4f758a607f540e026a"
  revision 2

  bottle do
    sha256 "c65c774606b4f4828b9ecaa9da78fb294c943ff95496288b9f75640cb2b10f53" => :yosemite
    sha256 "a90b22ee5bb19e9c2aff0e342fae61f66323608334b932b8be23023e20201d40" => :mavericks
    sha256 "cc9fd9634165a26fcadfc8a7ec9632fea2122c5458db368f6bc111fe4e6ccaea" => :mountain_lion
  end

  option "without-test", "Don't run build-time tests (may take a long time)"

  needs :openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xmi-msim" => :optional

  if build.with? "xmi-msim"
    depends_on "xraylib" => "with-fortran"
  else
    depends_on "xraylib"
  end

  fails_with :llvm do
    cause <<-EOS.undent
    llvm-gcc's OpenMP does not support the collapse statement,
    required to build xrmc
    EOS
  end

  def install
    inreplace Dir.glob("{examples,test}/*/Makefile.am"),
      "$(datadir)/examples/xrmc/", "$(datadir)/examples/"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-openmp
      --docdir=#{doc}
      --datarootdir=#{pkgshare}
    ]

    if build.with? "xmi-msim"
      args << "--enable-xmi-msim"
    else
      args << "--disable-xmi-msim"
    end

    system "autoreconf", "-fiv"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    cp_r (pkgshare/"examples/cylind_cell").children, testpath
    system bin/"xrmc", "input.dat"
  end
end

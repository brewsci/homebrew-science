class Xrmc < Formula
  desc "Monte Carlo simulation of X-ray imaging and spectroscopy experiments"
  homepage "https://github.com/golosio/xrmc"
  url "https://xrmc.tomschoonjans.eu/xrmc-6.5.0.tar.gz"
  sha256 "4995eaaf3b4583d443d0cf2003d73d1855b443938e431a4f758a607f540e026a"
  revision 2

  bottle do
    sha256 "8f0b3aa1e710873206b538625507233be81295c853d8d0aeb936ffc2491eea3b" => :el_capitan
    sha256 "1cb15f8682775c46458b0a456aceb92af4ca2db551447ca238cab479c5b96c8f" => :yosemite
    sha256 "5b528bf3ccbeeccf5891d9b7374933e6ec79385ba5c3fa72f7b761178c2d3a9f" => :mavericks
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

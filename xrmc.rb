class Xrmc < Formula
  desc "Monte Carlo simulation of X-ray imaging and spectroscopy experiments"
  homepage "https://github.com/golosio/xrmc"
  url "https://xrmc.tomschoonjans.eu/xrmc-6.6.0.tar.gz"
  sha256 "89c2ca22c44ddb3bb15e1ce7a497146722e3f5a0c294618cae930a254cbbbb65"

  bottle do
    sha256 "3c98fe0a3b3e5ee6214c8dd7f2f5198db6b3551bab582869767824842fd385d9" => :sierra
    sha256 "b4c39cabc73c192a5d602147309a973ed4cd2d92fb6a22ec0f4fc4665d18f7e1" => :el_capitan
    sha256 "ae287f540f1925817c8b2be79b0ac1fa27853a58fef3393640494471ae711f1a" => :yosemite
    sha256 "afbf7d38ce4db9fb9f4322b27ffbdd99486e786d4d93553fc05d295e67f8e221" => :x86_64_linux
  end

  option "without-test", "Don't run build-time tests (may take a long time)"

  needs :openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xraylib"
  depends_on "xmi-msim" => :optional

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

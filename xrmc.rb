class Xrmc < Formula
  homepage "https://github.com/golosio/xrmc"
  url "http://lvserver.ugent.be/xrmc/files/xrmc-6.5.0.tar.gz"
  mirror "https://xrmc.s3.amazonaws.com/xrmc-6.5.0.tar.gz"
  sha256 "4995eaaf3b4583d443d0cf2003d73d1855b443938e431a4f758a607f540e026a"

  depends_on "xraylib"
  depends_on "pkg-config" => :build
  needs :openmp
  depends_on "xmi-msim" => :optional
  option "with-check", "Run build-time tests (may take a long time)"

  fails_with :llvm do
    cause <<-EOS.undent
    llvm-gcc's OpenMP does not support the collapse statement,
    required to build xrmc
    EOS
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-openmp
    ]

    args << ((build.with? "xmi-msim") ? "--enable-xmi-msim" : "--disable-xmi-msim")

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    cp Dir.glob("#{share}/examples/xrmc/cylind_cell/*"), "."
    system "#{bin}/xrmc", "input.dat"
  end
end

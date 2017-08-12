class Emboss < Formula
  homepage "https://emboss.sourceforge.io/"
  url "ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.6.0.tar.gz"
  mirror "http://mirrors.mit.edu/gentoo-distfiles/distfiles/EMBOSS-6.6.0.tar.gz"
  mirror "http://science-annex.org/pub/emboss/EMBOSS-6.6.0.tar.gz"
  sha256 "7184a763d39ad96bb598bfd531628a34aa53e474db9e7cac4416c2a40ab10c6e"

  bottle do
    sha256 "767f04c1b36b859e0f53300216f607db99c5bebfb678295679cca110b24d1f64" => :yosemite
    sha256 "9de99047b806fa9c1235c49e63987c320de2ebc2c47bb1996e857edea9894fa8" => :mavericks
    sha256 "94d3635a7f03038733a86aac846693d0975f0891adb40b42b821e20ba468d106" => :mountain_lion
    sha256 "43e0496b75a896be3cb6281e0726867e072ba9bf18881ee127a33c5c56ede1d8" => :x86_64_linux
  end

  option "with-embossupdate", "Run embossupdate after `make install`"

  depends_on "pkg-config" => :build
  depends_on "libharu"    => :optional
  depends_on "gd"         => :optional
  depends_on "libpng"     => :recommended
  depends_on :x11         => :recommended
  depends_on :postgresql  => :optional
  depends_on :mysql       => :optional

  def install
    inreplace "Makefile.in", "$(bindir)/embossupdate", "" if build.without? "embossupdate"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --docdir=#{doc}
      --enable-64
      --with-thread
    ]
    args << "--without-x" if build.without? "x11"
    args << "--with-mysql" if build.with? "mysql"
    args << "--with-postgresql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end
end

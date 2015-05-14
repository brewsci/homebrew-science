class Libpll < Formula
  homepage "http://www.libpll.org/"
  url "http://www.libpll.org/Downloads/libpll-1.0.2.tar.gz"
  sha256 "c6112e95b2b34af0cc72208840281860b048588794c31f1f46c15ba5a0655e3d"
  head "https://git.assembla.com/phylogenetic-likelihood-library.git"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

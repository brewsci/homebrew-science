class Libpll < Formula
  homepage "http://www.libpll.org/"
  url "http://www.libpll.org/Downloads/libpll-1.0.2.tar.gz"
  sha256 "c6112e95b2b34af0cc72208840281860b048588794c31f1f46c15ba5a0655e3d"
  head "https://git.assembla.com/phylogenetic-likelihood-library.git"

  bottle do
    cellar :any
    sha256 "6d4886d7286af7ba1c7f4615bd1aab9af0a87a72d72767d8659b836649059a10" => :yosemite
    sha256 "0f9f835ab42cace506d68c8e90e47d5a558a0387297672592a1736057666c6bd" => :mavericks
    sha256 "7b0a93079fdbb1f063c940cb054dbba66267c06e6238fa40b5d96bbe67d77201" => :mountain_lion
  end

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

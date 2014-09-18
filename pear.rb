require "formula"

class Pear < Formula
  homepage "http://sco.h-its.org/exelixis/web/software/pear/"
  url "http://sco.h-its.org/exelixis/web/software/pear/files/pear-0.9.5-src.tar.gz"
  sha1 "5b8f5d887cef607b0d29d0e61916988a48e0d0a5"

  def install
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pear --help 2>&1 |grep -q pear"
  end
end

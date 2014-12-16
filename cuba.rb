require "formula"

class Cuba < Formula
  homepage "http://www.feynarts.de/cuba"
  url "http://www.feynarts.de/cuba/Cuba-4.1.tar.gz"
  sha1 "2415fb0d29e06a9b86eadb7750fe79bc77dd44c0"

  option "without-check", "Skip build-time tests (not recommended)"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--datadir=#{share}/cuba/doc"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

    (share / "cuba").install "demo"
  end

  test do
    system ENV.cc, "-o", "demo-c", "#{lib}/libcuba.a", "#{share}/cuba/demo/demo-c.c"
    system "./demo-c"
  end
end

require "formula"

class Cuba < Formula
  homepage "http://www.feynarts.de/cuba"
  url "http://www.feynarts.de/cuba/Cuba-4.1.tar.gz"
  sha1 "2415fb0d29e06a9b86eadb7750fe79bc77dd44c0"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ab45cb4ad7dee2a0ef6e6fb95b515dbee2ea8f6e" => :yosemite
    sha1 "0f2d8087ebe59c0d345b4aafa457023419e1656a" => :mavericks
    sha1 "3ff524e9b690162decc9dd89e163a42ca035f684" => :mountain_lion
  end

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

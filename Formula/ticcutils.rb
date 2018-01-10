class Ticcutils < Formula
  desc "Tools for the TiCC Software Stack"
  homepage "https://ilk.uvt.nl/ticcutils/"
  url "https://github.com/LanguageMachines/ticcutils/releases/download/v0.17/ticcutils-0.17.tar.gz"
  sha256 "4e5ed6b66a8595f4bdb75c46458723c6a8001a570ff47c068ea4e1ff1517c8a1"

  bottle do
    sha256 "1e960f04fdefbeb3f9876fe0ba78293a03449823268d860c1963b0fc9808a1fa" => :high_sierra
    sha256 "7b3b241ef5416eb4d7d7c4c5f536462a9dc567120be48391dc879d7cd30a7d54" => :sierra
    sha256 "7b6b842e5c94f26764826e54befcf3e532cd1895935c1700e84ab407e0e062cf" => :el_capitan
    sha256 "133d5fe533c76c272fbcf7c39414a1223fb007ade0486b4223445eb78a7ef52d" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "libxml2"
    depends_on "zlib"
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
  end
end

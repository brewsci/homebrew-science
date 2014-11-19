require "formula"

class Sally < Formula
  homepage "http://www.mlsec.org/sally"
  url "http://www.mlsec.org/sally/files/sally-0.9.2.tar.gz"
  sha1 "d4d430f8b6d2e71c4c7871f9d7b888a09dbe427b"

  head do
    url "https://github.com/rieck/sally.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libconfig"
  depends_on "libarchive" => :recommended

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/sally", "--version"
  end
end

require "formula"

class Sally < Formula
  homepage "http://www.mlsec.org/sally"
  url "http://www.mlsec.org/sally/files/sally-0.9.1.tar.gz"
  sha1 "8fb44d56e5c1112512c2d467b5fa76a2951af31a"

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

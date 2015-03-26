require "formula"

class Sally < Formula
  homepage "http://www.mlsec.org/sally"
  url "http://www.mlsec.org/sally/files/sally-1.0.0.tar.gz"
  sha256 "da706cb818fc2a3fc8f4a624d41010801ee8f96f0573b83be0c5fde886099148"

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

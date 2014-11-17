require "formula"

class Sally < Formula
  homepage "http://www.mlsec.org/sally"
  url "http://www.mlsec.org/sally/files/sally-0.9.1.tar.gz"
  sha1 "8fb44d56e5c1112512c2d467b5fa76a2951af31a"

  depends_on "pkg-config" => :build
  depends_on "libconfig"
  depends_on "libarchive" => :recommended

  def install
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

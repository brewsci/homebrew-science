require 'formula'

class Igraph < Formula
  homepage 'http://igraph.org'
  url 'http://igraph.org/nightly/get/c/igraph-0.7.0.tar.gz'
  sha1 '379d1cccec78435ff3fb7940d89ec9a2aa1de157'

  option :universal

  # GMP is optional, and doesn't have a universal build
  depends_on 'gmp' => :optional unless build.universal?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

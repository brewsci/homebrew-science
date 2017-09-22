class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  # tag "bioinformatics"
  # doi "10.1101/029827"

  url "https://github.com/marbl/Mash/archive/v2.0.tar.gz"
  sha256 "28f9b0d5ca646065b0b0b8c628552420fa61ac2904777a33c1856c4512640660"
  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any
    sha256 "7f03e15aa80fee4a4769e9ecd9c6e3ecdf1839556e1c1f0207e4bc4a3071389c" => :sierra
    sha256 "b88788e4a3c5c93291ec058c3d5c9d86758158b31062cf6619cbb4bb1346374b" => :el_capitan
    sha256 "e773c384eec8cb8dcd071fb66093414fd3ee75105532794ac9825aea41e16ef7" => :yosemite
    sha256 "7a14ecb6e92c3fd960f62fb9f76828c4a3b69a768e5b420db2c37034ba1b6af4" => :x86_64_linux
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "capnp"
  depends_on "gsl"
  depends_on "zlib" unless OS.mac?

  def install
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-capnp=#{Formula["capnp"].opt_prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}"
    system "make"
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
  end

  test do
    system bin/"mash", "-h"
  end
end

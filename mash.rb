class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  # tag "bioinformatics"
  # doi "10.1101/029827"

  url "https://github.com/marbl/Mash/archive/v1.1.1.tar.gz"
  sha256 "d2097267342a719cd831d1c58fe2b924ee4f4e918c8f7b2b7476f682f15ef623"
  revision 2

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

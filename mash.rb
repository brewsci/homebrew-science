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
    sha256 "a6533b182d4f0a600549f446562c43d315205952686aaa54270700d13e70305f" => :sierra
    sha256 "c99869b2652be4556b5b62ba83d291e541ee6d8b5db1d2d18350d4a3e5230c97" => :el_capitan
    sha256 "0e4fd774c5ef62ab1fe33c54164f26621951e0632bf8501957df8f49cd677c2f" => :x86_64_linux
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

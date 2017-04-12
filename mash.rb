class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  # tag "bioinformatics"
  # doi "10.1101/029827"

  url "https://github.com/marbl/Mash/archive/v1.1.1.tar.gz"
  sha256 "d2097267342a719cd831d1c58fe2b924ee4f4e918c8f7b2b7476f682f15ef623"
  revision 1

  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any
    sha256 "f047fcf2ee8b811c2c23a2716796781799a3e5ed4512669662d886197eb14a73" => :el_capitan
    sha256 "b992bc061d2a5aa75e96421933495bf34ef567056fa67df6b3ca92781a95399e" => :yosemite
    sha256 "db8deedd40e695d6b90b609d4a208b1bc1233e01d5e24e0703ac8d68ce91082b" => :mavericks
    sha256 "33a8f8bb68461efa0c6eea4efa247ea1974590e59c79e8d4bdcb65efb58d3427" => :x86_64_linux
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

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
    sha256 "5e3943bf2109fd40c887da7b326deaa051f67e7d19922472bfce64750ab12090" => :el_capitan
    sha256 "c774563328d0f663bd180fb86fb56fc9d5474ae552a31baf8ed56fbf65c4ac95" => :yosemite
    sha256 "303dcd0cd0df7e3ba8da92e2c6d32b578d6c69983ffd940bb278109c6b4aff86" => :mavericks
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "capnp"
  depends_on "gsl"

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

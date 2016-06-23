class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  # tag "bioinformatics"
  # doi "10.1101/029827"

  url "https://github.com/marbl/Mash/archive/v1.1.tar.gz"
  sha256 "ef79c5e1dbfe64c289a2bd1f5afa272041508500e1f28353aef8bd12fe5dc41d"

  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any
    sha256 "4a2f551a2ef6e9e3d1b000e6aff11f50577f0aca0059df0a6156ac7d7f866d6f" => :el_capitan
    sha256 "4f3aa78846e4ca05e350a3e1b1922c9ec2cac83e6604979ed0149d6fc06a002f" => :yosemite
    sha256 "d8a1d9928e64b59cc38e1674cc8564f96a262f8b2d43fef00351cc19fa8b7768" => :mavericks
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
    assert_match "Estimate the distance", shell_output("#{bin}/mash -h 2>&1", 0)
  end
end

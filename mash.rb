class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  bottle do
    cellar :any
    sha256 "0c658874e506b0259ccd52cf8932ebd2997ede7265609d2fd8d67cc1eb34da20" => :el_capitan
    sha256 "e0776514d2c979fe91dbc9c4066910a5b6d4b0bb2a3607f0f98cdfd59d9d1805" => :yosemite
    sha256 "b7ca6dfa15ed9eb9bad6d29fd5fbca5253c485527f1ca8f78a4acbece4865a8b" => :mavericks
  end

  # tag "bioinformatics"

  url "https://github.com/marbl/Mash.git",
    :revision => "cf35751bd8936dba80ed5c489f823fdd3507d340"
  version "0.001"

  head "https://github.com/marbl/Mash.git"

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
    assert_match "Estimate the distance", shell_output("mash -h 2>&1", 0)
  end
end

class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
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

class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  # tag "bioinformatics"
  # doi "10.1101/029827"

  url "https://github.com/marbl/Mash/archive/v1.0.1.tar.gz"
  sha256 "4ef85ea799e2beb27b21248864f74c617c78f075c1c2e4599bddcda4815e58d0"

  head "https://github.com/marbl/Mash.git"

  bottle do
    cellar :any
    sha256 "fc91a72acfaefca83116979a98fba390b691605083af11912119fcb26525f45a" => :el_capitan
    sha256 "efad6350d15d14a8f12f15ca639116aa89cb462e7901c1939e15fe1c845408c1" => :yosemite
    sha256 "6a5d522da7d690dd230a55dff793d1a60c305f20bc6a277e72141f97a4377181" => :mavericks
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
    assert_match "Estimate the distance", shell_output("mash -h 2>&1", 0)
  end
end

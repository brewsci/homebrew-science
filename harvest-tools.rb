class HarvestTools < Formula
  homepage "https://github.com/marbl/harvest-tools"
  # doi "10.1186/s13059-014-0524-x"
  # tag "bioinformatics"
  url "https://github.com/marbl/harvest-tools/archive/v1.2.tar.gz"
  sha256 "6f9a7ab056d52fad78bdb7a93832ff8b509b77566c22481a2d81089736e10af4"

  bottle do
    sha1 "8a1e63ffa7954e78d8038284dc7d771c22a29a25" => :yosemite
    sha1 "c903c72ff4da08c195a25a14d13b3c60d1612b73" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "capnp"
  depends_on "protobuf"

  # Fixes --with-capnp configure flag
  patch do
    url "https://github.com/marbl/harvest-tools/commit/c20b1a490d488c4a5bf7ca45a3012a4058bbbf2f.diff"
    sha256 "cec995a1a2dde25c795bc7a1d90f5f6aea38c7e60f2d953d9bf3569f75364e53"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}",
           "--with-protobuf=#{Formula["protobuf"].opt_prefix}",
           "--with-capnp=#{Formula["capnp"].opt_prefix}"
    system "make", "all"

    include.install "src/harvest"
    lib.install "libharvest.a"
    bin.install "harvesttools"
    pkgshare.install "test"
  end

  test do
    system "#{bin}/harvesttools", "-f", "#{pkgshare}/test/test2.fna",
                                  "-x", "#{pkgshare}/test/test2.xmfa",
                                  "-v", "#{pkgshare}/test/test2.vcf",
                                  "-o", "out.ggr"
    assert File.exist?("out.ggr")
  end
end

class HarvestTools < Formula
  desc "Utility for creating and interfacing with Gingr files"
  homepage "https://github.com/marbl/harvest-tools"
  # doi "10.1186/s13059-014-0524-x"
  # tag "bioinformatics"
  url "https://github.com/marbl/harvest-tools/archive/v1.2.tar.gz"
  sha256 "6f9a7ab056d52fad78bdb7a93832ff8b509b77566c22481a2d81089736e10af4"
  revision 1

  head "https://github.com/marbl/harvest-tools.git"

  bottle do
    sha256 "7051d0d9403aa94a5986aa18b02515b6c03b4075238d0bbd5f482577db5942b5" => :el_capitan
    sha256 "18661add81319869a30b07662f86099509978434bab7d0af37faec5b4b100e0e" => :yosemite
    sha256 "022ab27d877d18c2f49d54fa3dccd28b554ad92ba4d22787f93b3a48239c5554" => :mavericks
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

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
    sha256 "9fdf80746d5a9aee3e8a532316c5803f67cb327bc443544bc563ac642f336cea" => :yosemite
    sha256 "01a6c4e6f7a5f83cc2c037911526bba1e092c2de0e066447e9145359230ccbc3" => :mavericks
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

class HarvestTools < Formula
  homepage "https://github.com/marbl/harvest-tools"
  # doi "10.1186/s13059-014-0524-x"
  # tag "bioinformatics"
  url "https://github.com/marbl/harvest-tools/archive/v1.1.tar.gz"
  sha1 "bc788b7f3c62ff1f9570b563ef0b944f95bbb314"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "8a1e63ffa7954e78d8038284dc7d771c22a29a25" => :yosemite
    sha1 "c903c72ff4da08c195a25a14d13b3c60d1612b73" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "protobuf"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}",
                          "--with-protobuf=#{Formula["protobuf"].opt_prefix}"
    system "make", "all"

    include.install "src/harvest"
    lib.install "libharvest.a"
    bin.install "harvesttools"
    share.install "test"
  end

  test do
    system "#{bin}/harvesttools", "-f", "#{share}/test/test2.fna",
                                  "-x", "#{share}/test/test2.xmfa",
                                  "-v", "#{share}/test/test2.vcf",
                                  "-o", "out.ggr"
    assert File.exist?("out.ggr")
  end
end

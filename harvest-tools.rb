class HarvestTools < Formula
  homepage "https://github.com/marbl/harvest-tools"
  # doi "10.1186/s13059-014-0524-x"
  # tag "bioinformatics"
  url "https://github.com/marbl/harvest-tools/archive/v1.1.tar.gz"
  sha1 "bc788b7f3c62ff1f9570b563ef0b944f95bbb314"

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

class Ococo < Formula
  desc "Ococo, the first online consensus caller"
  homepage "https://github.com/karel-brinda/ococo"
  url "https://github.com/karel-brinda/ococo/archive/0.1.2.4.tar.gz"
  sha256 "1716b012acd7e08949ccfbc491d8b018c69b10128bff558f43624a176c871109"

  head "https://github.com/karel-brinda/ococo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2708bd14a7ee3339a7934de5c98b6c1050d3384aaaae070e254ddb9c2b290379" => :el_capitan
    sha256 "48fe3507e28ecb56300e576c7ee9b7f89bb9b3f8eddd0f1690cec2c049d41992" => :yosemite
    sha256 "6035fc4acf5ae5591e8bfb18d6c2b7f4e23849ade637f1a58c0410d83ff37543" => :mavericks
  end

  depends_on "htslib"
  depends_on "xz"

  def install
    inreplace "Makefile", /^(LIBS +)( =.*)/, "\\1\\2\n\\1+= -llzma -lbz2"
    system "make", "HTSLIBINCLUDE=#{Formula["htslib"].opt_include}", "HTSLIB=#{Formula["htslib"].opt_lib}/libhts.a"
    bin.install "ococo"
    man1.install "ococo.1"
  end

  test do
    system "#{bin}/ococo", "-v"
    (testpath/"test.sam").write "@SQ\tSN:chrom1\tLN:42424242\nread\t0\tchrom1\t2798553\t60\t5M\t*\t0\t0\tAAAGG\t*"
    assert_match "5", shell_output("#{bin}/ococo -i test.sam -P - 2>/dev/null | wc -l")
  end
end

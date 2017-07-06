class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.3.tar.gz"
  sha256 "66491182584eed31a323324e8478042c8752c112d13ef7c4c66540b4f9df431d"

  revision 2

  bottle do
    cellar :any
    sha256 "083ac6559faca0ab8fd43b2fc90171032521bdff6e1aa52306faa2ea30dd9fa1" => :sierra
    sha256 "f082b9979c6f11be9d824405b4b2bdc27d4f71842ed284fcadc2a03aec006e6e" => :el_capitan
    sha256 "f8f1e19e94a4da11af2650cf07ce6b824138930a91a894f43475858aef526c70" => :yosemite
    sha256 "122dcadcb3245e7b048a61f3a6d3bbdc7b6f4f231b67bcd459e511b949647b7d" => :x86_64_linux
  end

  depends_on "openfst"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # see http://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r share/"thrax/grammars", testpath
    cd "grammars" do
      system "#{bin}/thraxmakedep", "example.grm"
      system "make"
      system "#{bin}/thraxrandom-generator", "--far=example.far",
                                      "--rule=TOKENIZER"
    end
  end
end

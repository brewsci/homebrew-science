class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.3.tar.gz"
  sha256 "66491182584eed31a323324e8478042c8752c112d13ef7c4c66540b4f9df431d"

  revision 1

  bottle do
    cellar :any
    sha256 "77c822ef900109767aa57a361150b15ba4d135462b8f5796a5844d795f03f8ba" => :sierra
    sha256 "03d906c22157ecf2c31d4d7f865be93ba099a013d8e6bbaa8c1b8cd207b5969f" => :el_capitan
    sha256 "51fb9e88d762a04e37cd285fdb9d040746e8abea6a774e5b8e44724790d9d7aa" => :yosemite
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

class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.1.tar.gz"
  sha256 "3710feefe7bdb462b032b169946b8338a4c1220181a5dcc3ef798d5d09adccdc"

  bottle do
    cellar :any
    sha256 "733b4e50e0f4b4c2a9fa70c2d5c726839362278e75c642da8678b7b399d5f063" => :el_capitan
    sha256 "bebcb831bf02f50a7d7392a73fc16211cc8174fa5b59b0e5e9f2f85bd07bb78b" => :yosemite
    sha256 "280764de8aa5b7b18770b47a07eb80ccdfb9b1d406b72bceed75f248aff9f92f" => :mavericks
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
      system "thraxmakedep", "example.grm"
      system "make"
      system "thraxrandom-generator", "--far=example.far",
                                      "--rule=TOKENIZER"
    end
  end
end

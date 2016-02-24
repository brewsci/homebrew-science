class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.1.tar.gz"
  sha256 "3710feefe7bdb462b032b169946b8338a4c1220181a5dcc3ef798d5d09adccdc"

  bottle do
    cellar :any
    sha256 "041d8eac5624c0f812f701e825ab5c675daa698523b1819b144722ec0689c5bd" => :el_capitan
    sha256 "52d6ec14148f99a5a110365c232f879550b13b28b0ffca4f37700bde1d0fb5df" => :yosemite
    sha256 "036dbbc989df705217c2bf820b07650c21e13026bd6aac4f237e982cbc0ecdda" => :mavericks
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

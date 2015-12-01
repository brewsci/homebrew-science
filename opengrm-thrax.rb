class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.1.0.tar.gz"
  sha256 "ce99d5b9b67b0d4ef3c9d7003aebad37f31235ef03191a44b11facd8e1b917da"

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
    cd "#{share}/thrax/grammars" do
      system "thraxmakedep", "example.grm"
      system "make"
      system "thraxrandom-generator", "--far=example.far",
                                      "--rule=TOKENIZER"
    end
  end
end

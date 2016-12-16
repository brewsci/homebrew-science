class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.2.tar.gz"
  sha256 "d1744b15ea142e172713c1645451e743a78e1731bb285ec0f4ea5c118d1dcfe7"
  revision 1

  bottle do
    cellar :any
    sha256 "21c40ec146980d93b01e3c6ca11e2471686a8fd0cbe8b484cf9a2ff8760db61f" => :sierra
    sha256 "6d60196b59fe7c33d31dac0271ababe14f577ecb44e70c526888c6d9c215d228" => :el_capitan
    sha256 "bc13af8bdd95948bdd28bd405f868d4dfd18f5c2395ac223885b5cb6fab2c0fb" => :yosemite
    sha256 "5938e804e2d8fa6f15f27a4a4e4f82554698a3a7d43e01531a1ed87860284729" => :x86_64_linux
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

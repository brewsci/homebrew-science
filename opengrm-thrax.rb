class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.2.tar.gz"
  sha256 "d1744b15ea142e172713c1645451e743a78e1731bb285ec0f4ea5c118d1dcfe7"
  revision 1

  bottle do
    cellar :any
    sha256 "9a2c63a57067e38d39be1a4299401ed87a89b899f26e96742fc3ccbc588f084c" => :el_capitan
    sha256 "893fda3d8f2539e45d66a49eac9dab81069d3bb04cd849a79377b2ef722bab3c" => :yosemite
    sha256 "385d96d3bfda3b50fe7b512a3ffadbde175a7de6d336a8d34bccd0e532e43169" => :mavericks
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

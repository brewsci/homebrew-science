class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.0.tar.gz"
  sha256 "23112837b64634685e34681758b42b55d09b97b999c2f8a43c0002b870f98fc9"

  bottle do
    cellar :any
    sha256 "f032fee5025fab68762f3deb51d685efcd62d84d3b2e4608efbd45264e09a91b" => :el_capitan
    sha256 "8ead70b3f81a3de2fab6f9bc6157b009dcb831404fc4fc6e8630c35d1bd0821d" => :yosemite
    sha256 "20047bcb6ca03c89a7a531f302709e48908665e260c6f995e6864f67876a2ad2" => :mavericks
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

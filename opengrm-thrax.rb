class OpengrmThrax < Formula
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.2.3.tar.gz"
  sha256 "66491182584eed31a323324e8478042c8752c112d13ef7c4c66540b4f9df431d"

  revision 1

  bottle do
    cellar :any
    sha256 "4758541a70673c2b50a1745a99de161fcc56879660ddd726af36e27b10b01f0d" => :sierra
    sha256 "769a364203257d8a5859e97c47c2cb7cf46ece5da5de8bd212626187e3cacf3e" => :el_capitan
    sha256 "6099dbafc20f24d00915767da4ed48f3ea193f1a954cc7e3e66e3d83a9a17bec" => :yosemite
    sha256 "22b78b68c53d351afbd1c740aace41fafc828a5e4ceb2a9513bbf0774a419eab" => :x86_64_linux
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

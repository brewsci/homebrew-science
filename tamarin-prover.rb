class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.2.1.tar.gz"
  sha256 "3c8a91c23896f61f1c04b8121125b3fd603191522512ef5a459260d89fdd911a"
  revision 1
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cbaf97d5446ddb0f3201cad497cc2cb93a9a8bc662d16c45f0f69c784ab2531" => :sierra
    sha256 "3614cdaf2f05d9d2d0a4a892116f77c84a593a7239146d510c20c50d269338ad" => :el_capitan
    sha256 "2b2cee8f7439698171ecc1fc31e171439a711e7831aad035be64e34adb478e91" => :yosemite
  end

  depends_on "haskell-stack" => :build
  depends_on "ocaml" => :build
  depends_on "maude"
  depends_on "graphviz"
  depends_on :macos => :mountain_lion

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    # Deparallelization prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
    ENV.deparallelize
    system "make", "default"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end

class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.2.1.tar.gz"
  sha256 "3c8a91c23896f61f1c04b8121125b3fd603191522512ef5a459260d89fdd911a"
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  depends_on "haskell-stack" => :build
  depends_on "maude"
  depends_on "graphviz"
  depends_on :macos => :mountain_lion

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    # This deparallelization prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
    ENV.deparallelize do
      system "make", "tamarin"
    end

    bin.install ".brew_home/.local/bin/tamarin-prover"
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end

class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.2.1.tar.gz"
  sha256 "3c8a91c23896f61f1c04b8121125b3fd603191522512ef5a459260d89fdd911a"
  revision 1
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "efcddecba5a44614f4432e0559feb17e343717543c6338adab1e9a1d87cf24ef" => :sierra
    sha256 "1daceba42bff6d839fbf6a5b7c045e074f66a369400d6f4a2084a7a639b5dd5c" => :el_capitan
    sha256 "8a39f8e710df32565883a36214302b235f1e5a219a70b4bb7816e2a4e326aff0" => :yosemite
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

class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.2.2.tar.gz"
  sha256 "f9b2d3acc01b89f71d2b246a6b3010ebab71e4fe309b3be8a8eac213422b43de"
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "efcddecba5a44614f4432e0559feb17e343717543c6338adab1e9a1d87cf24ef" => :sierra
    sha256 "1daceba42bff6d839fbf6a5b7c045e074f66a369400d6f4a2084a7a639b5dd5c" => :el_capitan
    sha256 "8a39f8e710df32565883a36214302b235f1e5a219a70b4bb7816e2a4e326aff0" => :yosemite
    sha256 "945abac8994c7c98c165247a638207b319952fe7fb372e79a00138d7e291a12a" => :x86_64_linux
  end

  depends_on "haskell-stack" => :build
  depends_on "ocaml" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "maude"
  depends_on "graphviz"
  depends_on :macos => :mountain_lion

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    # Deparallelization prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
    ENV.deparallelize
    jobs = ENV.make_jobs
    system "stack", "-j#{jobs}", "setup"
    args = []
    args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}" unless OS.mac?
    system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"
    system "make", "sapic"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end

class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.2.2.tar.gz"
  sha256 "f9b2d3acc01b89f71d2b246a6b3010ebab71e4fe309b3be8a8eac213422b43de"
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "73d09465fd0af798b11f94d9a845342b4c97b1a4345d6a9425bef89242b34924" => :sierra
    sha256 "5f9265c596f44a2b508ef7cbe007e05fd9b63fd8a1cbaf9fbc3b88b609dcecbd" => :el_capitan
    sha256 "b2e7524e1e6705a9527eeaa3e307b47ea87d669166fef3f2044390e69c912e26" => :yosemite
    sha256 "80902c79777872f6fca7965f82b6d901a0e3e5ae79aab1b6f49df52ab708bffb" => :x86_64_linux
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

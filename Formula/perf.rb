class Perf < Formula
  desc "Program to measure the performance of the predictions you submit"
  homepage "http://osmot.cs.cornell.edu/kddcup/software.html"
  url "http://osmot.cs.cornell.edu/kddcup/perf/perf.src.tar.gz"
  version "5.11"
  sha256 "61b8d7adecc069e46c4fe9882350c69a0007c2f706be469458a9b41de0f65942"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf28fc7f7acd7c56aca805479d272f2ac2733036088071825ad337c152db077e" => :sierra
    sha256 "cbd2ecc8b489cec088d5d0d25cd6d9832f2a03a62ebbca65cc1c9b406954720c" => :el_capitan
    sha256 "6e43efcca9ceb7fc63ff4e034d9fd141173931aae3a36304ea0ac708394b55d3" => :yosemite
    sha256 "dd4fde86f5340be9b277290b2d7af12cef8ce2d6897b84a568f9e58d5a3b1f0c" => :x86_64_linux
  end

  def install
    File.delete "perf"
    system "make"
    bin.install "perf"
  end

  test do
    (testpath/"test.data").write <<-EOS.undent
      1 0.80962
      0 0.48458
      1 0.65812
      0 0.16117
      0 0.47375
      0 0.26587
      1 0.71517
      1 0.63866
      0 0.36296
      1 0.89639
      0 0.35936
      0 0.22413
      0 0.36402
      1 0.41459
      1 0.83148
      0 0.23271
    EOS

    output = `#{bin}/perf -ACC < test.data`

    output == "ACC    0.93750   pred_thresh  0.500000\n"
  end
end

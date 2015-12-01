class Perf < Formula
  homepage "http://osmot.cs.cornell.edu/kddcup/software.html"
  url "http://osmot.cs.cornell.edu/kddcup/perf/perf.src.tar.gz"
  sha256 "61b8d7adecc069e46c4fe9882350c69a0007c2f706be469458a9b41de0f65942"
  version "5.11"

  def install
    system "rm perf"
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

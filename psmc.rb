class Psmc < Formula
  desc "Pairwise Sequentially Markovian Coalescent (PSMC) model"
  homepage "https://github.com/lh3/psmc"
  # doi "10.1038/nature10231"
  # tag "bioinformatics"

  url "https://github.com/lh3/psmc/archive/0.6.5.tar.gz"
  sha256 "0954b3e28dda4ae350bdb9ebe9eeb3afb3a6d4448cf794dac3b4fde895c3489b"

  head "https://github.com/lh3/psmc.git"

  def install
    system "make"
    system "make", "-C", "utils"
    bin.install "psmc"
    doc.install "README"
    bin.install Dir["utils/*"].select { |x| File.executable?(x) && !x.end_with?(".c") }
  end

  test do
    assert_match "Usage", shell_output("#{bin}/psmc 2>&1", 1)
  end
end

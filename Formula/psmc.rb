class Psmc < Formula
  desc "Pairwise Sequentially Markovian Coalescent (PSMC) model"
  homepage "https://github.com/lh3/psmc"
  url "https://github.com/lh3/psmc/archive/0.6.5.tar.gz"
  sha256 "0954b3e28dda4ae350bdb9ebe9eeb3afb3a6d4448cf794dac3b4fde895c3489b"
  head "https://github.com/lh3/psmc.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, yosemite:      "fc899e94c6d9eaafaaacb1af70d3aa074bb0cd4c8f8d9895670c2ba8b3e6f761"
    sha256 cellar: :any, mavericks:     "2c45d58d00910f8502bae0bf520ee345093bf57cb24edfb02252fccbdf062f53"
    sha256 cellar: :any, mountain_lion: "af3b4d8927a341412c0d4dbde99ddb0f88dd28bc1250079c24d4846c3816d066"
    sha256 cellar: :any, x86_64_linux:  "393528a080f7953435fde83fa3f1a42fbfe7f6f746780a573f9dd0d37e59e936"
  end

  # doi "10.1038/nature10231"
  # tag "bioinformatics"

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

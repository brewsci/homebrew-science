class Hisat < Formula
  homepage "https://ccb.jhu.edu/software/hisat/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.3317"
  url "https://ccb.jhu.edu/software/hisat/downloads/hisat-0.1.6-beta-source.zip"
  version "0.1.6b"
  sha256 "69fbd79d8f29b221aa72f0db33148d67d44a3e2cfe16dadf0663a58b7741ff9c"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, yosemite:      "e34b8f4f30502f56398a2d261bb7da2ff3a597c3ca52a4feb4e460bb99006e8f"
    sha256 cellar: :any, mavericks:     "8d6569d480eaddde24e587df969e177a8fef78430aece34fb20e25429878c5ac"
    sha256 cellar: :any, mountain_lion: "27f1b26e3d83bc9ac3275b2b5d80c69205043813efd8677755ec671791d6cb89"
    sha256 cellar: :any, x86_64_linux:  "4b4aaf7061565de3833c7d075b973d1420c5d7d859f0c8291a46a6ee317d49ae"
  end

  def install
    system "make"
    bin.install "hisat", Dir["hisat-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "HISAT", shell_output("hisat 2>&1", 1)
  end
end

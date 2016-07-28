class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder/archive/v3.0.0.tar.gz"
  sha256 "b5a1ad48c0df64bb539709e523418bbe197d0342bd2fae40e035234946bcaeb6"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  head "https://github.com/TransDecoder/TransDecoder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce741f3518c5cb58affd3b81448c15e744ebe94aebdd5643b48862cf05834eb2" => :el_capitan
    sha256 "4a50568376ef0523f282e83df50e022d967c96973cbbefc39facab97c5203f85" => :yosemite
    sha256 "eff88daefa4b2d0478e396c96f6106d6930cde4a096efad125a2cd544cab1c9c" => :mavericks
  end

  depends_on "cd-hit"

  def install
    # Remove the cd-hit source code
    rm_rf "transdecoder_plugins"

    prefix.install Dir["*"]
    bin.install_symlink "../TransDecoder.LongOrfs", "../TransDecoder.Predict"
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.LongOrfs 2>&1", 1)
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.Predict 2>&1", 1)
  end
end

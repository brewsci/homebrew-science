class Transdecoder < Formula
  homepage "https://transdecoder.github.io/"
  # tag "bioinformatics"

  url "https://github.com/TransDecoder/TransDecoder/archive/2.0.1.tar.gz"
  sha256 "ce069da72c8a04e739f8c057af4f97187bf587d3f0d3db40465dfc2c89393e22"

  head "https://github.com/TransDecoder/TransDecoder.git"

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

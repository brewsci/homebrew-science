class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder/archive/v3.0.0.tar.gz"
  sha256 "b5a1ad48c0df64bb539709e523418bbe197d0342bd2fae40e035234946bcaeb6"
  head "https://github.com/TransDecoder/TransDecoder.git"
  # tag "bioinformatics"

  head "https://github.com/TransDecoder/TransDecoder.git"

  bottle do
    cellar :any
    sha256 "559044bf89f298ede284e3a9f72ef0fc7bd6c912e2b5ee753ceade016370d704" => :yosemite
    sha256 "fae619c6f41eec60f5bf1bd76af2b110253be8fee275c7610c3bf7ac80873b02" => :mavericks
    sha256 "549db77a17285d8a616d64e1e6b9baf21e3beb9e424d6427dfce9af43737c30a" => :mountain_lion
    sha256 "36447454b2c6504477ef1335989cad531efaa4c2032646e6d8356b440625cbaf" => :x86_64_linux
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

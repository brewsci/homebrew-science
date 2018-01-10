class Deeplearning4jCli < Formula
  desc "Command-line interface for Deeplearning4j"
  homepage "https://deeplearning4j.org/"
  url "https://s3-us-west-2.amazonaws.com/skymind/bin/deeplearning4j-cli.tar.gz"
  version "0.4-rc3.8"
  sha256 "aaa664958f5d53570d02d75e7f61a491f5f75372d5721bf4f6c1efe31e971fcb"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    inreplace "bin/dl4j", "$DIR/../lib", libexec
    bin.install "bin/dl4j"
    libexec.install Dir["lib/*"]
  end

  test do
    system "#{bin}/dl4j"
  end
end

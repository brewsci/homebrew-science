class Platypusvar < Formula
  desc "It is variant-detection in high-throughput sequencing data"
  homepage "http://www.well.ox.ac.uk/platypus"
  url "http://www.well.ox.ac.uk/bioinformatics/Software/Platypus-latest.tgz"
  version "0.8.1"
  sha256 "a0f39e800ebdc5590e9b568a791bc6746df0fde4d1c3622140db64dea175622b"

  depends_on "htslib"
  depends_on :python unless OS.mac?

  def install
    system "python", "setup.py", "build"
    prefix.install "LICENSE", "README.txt", Dir["*.py"], Dir["build/lib*/*"]
    bin.install_symlink "../Platypus.py", "Platypus.py" => "platypusvar"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/platypusvar callVariants --help")
  end
end

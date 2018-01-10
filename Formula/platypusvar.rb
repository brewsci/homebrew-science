class Platypusvar < Formula
  desc "It is variant-detection in high-throughput sequencing data"
  homepage "http://www.well.ox.ac.uk/platypus"
  url "http://www.well.ox.ac.uk/bioinformatics/Software/Platypus-latest.tgz"
  version "0.8.1"
  sha256 "a0f39e800ebdc5590e9b568a791bc6746df0fde4d1c3622140db64dea175622b"

  bottle do
    cellar :any
    sha256 "941e81e14e2237a2fea587f4843d9a4247dda9144f15d39556039072668f28cb" => :sierra
    sha256 "5b59b3e929a2b81030e76aecc1976674f50d10c5dd252586f8373f91a9ea0503" => :el_capitan
    sha256 "576272fc462c6fa7898b797831e43e26ef02e3046e5401b8e11ee36d03777beb" => :yosemite
    sha256 "589b5cf55db4507edeac3f4845de08523e3900482920676dfecc8e8fe1dd216b" => :x86_64_linux
  end

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

class Platypusvar < Formula
  desc "It is variant-detection in high-throughput sequencing data"
  homepage "http://www.well.ox.ac.uk/platypus"
  url "http://www.well.ox.ac.uk/bioinformatics/Software/Platypus-latest.tgz"
  version "0.8.1"
  sha256 "a0f39e800ebdc5590e9b568a791bc6746df0fde4d1c3622140db64dea175622b"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "941e81e14e2237a2fea587f4843d9a4247dda9144f15d39556039072668f28cb"
    sha256 cellar: :any, el_capitan:   "5b59b3e929a2b81030e76aecc1976674f50d10c5dd252586f8373f91a9ea0503"
    sha256 cellar: :any, yosemite:     "576272fc462c6fa7898b797831e43e26ef02e3046e5401b8e11ee36d03777beb"
    sha256 cellar: :any, x86_64_linux: "589b5cf55db4507edeac3f4845de08523e3900482920676dfecc8e8fe1dd216b"
  end

  depends_on "htslib"
  depends_on "python" unless OS.mac?

  def install
    system "python", "setup.py", "build"
    prefix.install "LICENSE", "README.txt", Dir["*.py"], Dir["build/lib*/*"]
    bin.install_symlink "../Platypus.py", "Platypus.py" => "platypusvar"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/platypusvar callVariants --help")
  end
end

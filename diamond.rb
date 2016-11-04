class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.26.tar.gz"
  sha256 "00d2be32dad76511a767ab8e917962c0ecc572bc808080be60dec028df45439f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a005f7cd13b095719865e2a95f5b0bead47f77229fd785243ad75a1eafba932" => :sierra
    sha256 "1adc3bc49015f873767c545cb696e0dfa92b5be5f77280ac655b94aefc2e8847" => :el_capitan
    sha256 "b4660954a381a79d9014b00a599c692d66e97491ee45e7b360b15674f034d720" => :yosemite
    sha256 "4302219ad5f2b00c79c7c68ad1c0c88c53599f6c31d53996b2348ab966755d16" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end

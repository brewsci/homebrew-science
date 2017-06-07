class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.6.tar.gz"
  sha256 "1e71a2a50aca46c46f1ac1647bbf8ec7b5c59b3c488b398f7dfb966416080af9"

  bottle do
    cellar :any_skip_relocation
    sha256 "54dbb7a37ba9615e1271a794016f13b9f3aad3ad243aee6e07e94ed535449ce3" => :sierra
    sha256 "2c00c4b314b22f6895516d05df479bd9f4be77eb935f61429d3017454f230f0d" => :el_capitan
    sha256 "6d72a45f46861d7519da091cdb23f9ecba99c6c37dce2763c345031959f47ed2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  patch do
    url "https://github.com/bbuchfink/diamond/commit/0b15aa3.patch"
    sha256 "0c78f66bd115783d5f8f86e21e958d3b84c05c225dcaed05d942e0e74ac2c22e"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end

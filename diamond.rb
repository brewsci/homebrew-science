class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.6.tar.gz"
  sha256 "1e71a2a50aca46c46f1ac1647bbf8ec7b5c59b3c488b398f7dfb966416080af9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9c9526a8288db38885b5eadaeb26035bb6c4f63c4c0592279267fa907de08ba" => :sierra
    sha256 "d23b4b8218c6536018c28dcc02eea8be6bde2e8c9efd2aef07b6e13e04e343d6" => :el_capitan
    sha256 "b90c0f7c4152be0c60cc3549ed5344e319cb945937151153857198e1edb46f88" => :yosemite
    sha256 "9a6da3f3a602e05eef1c4e987bc443a4871498562e391fd975b23c62628ba634" => :x86_64_linux
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

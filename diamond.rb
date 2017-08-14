class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.10.tar.gz"
  sha256 "0dafd2180466e3617a949cc33bd5ff6ce1673adac3967a11c4ad58521eff188f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e13796f241e29cd224f298b32e7eefe36f8b541bdc93720bfdf912fbc262dea" => :sierra
    sha256 "dd1cc9df59368a0e83b5f0ff46b4e28ba2c7a8bd93748d6c2a64fb8db878c4a6" => :el_capitan
    sha256 "a817a99b3469f3c1eb8265d74d9113c2a46ac7df9d7009872507096092140268" => :yosemite
    sha256 "9e6a0de077a1544e6fd671b004a3b1899c3feb4eab9b2f304844b60f19a8e7bf" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end

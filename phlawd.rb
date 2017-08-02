class Phlawd < Formula
  desc "Phylogenetic dataset construction"
  homepage "http://www.phlawd.net/"
  url "https://github.com/jonchang/phlawd/archive/3.4b.tar.gz"
  version "3.4b"
  sha256 "a0fea43866e425f7fed5f74bcb8c391484a10b486f3f03d5b7bbc4df84dd84b8"
  head "https://github.com/jonchang/phlawd.git"
  # doi "10.1186/1471-2148-9-37"
  # tag "bioinformatics"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eab194f5f8a40fffc3801a179d8b794c28ff29232cd2a666a05fe34913c2cdbe" => :sierra
    sha256 "98172e8ee0bce6476d8c39e8bda5bfe6bc9ac582a41c5be2507d3f8a527bc5c4" => :el_capitan
    sha256 "147f7deae6e1c6c0f3697ed7f3c893b338bc147fb0fc2a4f28054806982b5fef" => :yosemite
    sha256 "c51b6f732f0acb671eecdf4604fb4603fa4e5f40dad96e77d6e0f47b5475d872" => :x86_64_linux
  end

  needs :openmp

  depends_on "gcc" if OS.mac?
  depends_on "wget"
  depends_on "mafft"
  depends_on "muscle"
  depends_on "quicktree"
  depends_on "sqlite"

  def install
    cd "src" do
      system "./configure"
      system "make"
      bin.install "PHLAWD"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/PHLAWD")
  end
end

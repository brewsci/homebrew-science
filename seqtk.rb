class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/5b8ebb23e9a81466c901a46d089f29c4a1cecfa5.tar.gz"
  version "77"
  sha1 "9c50cc5aceca0450a0cf9cf854c2bad7ebde5a1d"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "8c2975651cea0d3af8f4b611719376497e3d0d8a" => :yosemite
    sha1 "d54e3028681e6e2d8918f7639ae7542e9ca0256a" => :mavericks
    sha1 "627d5b9a787b2d167d328b29df668935078c50f6" => :mountain_lion
  end

  def install
    system "make"
    bin.install "seqtk"
    doc.install "README.md"
  end

  test do
    assert_match "seqtk", shell_output("#{bin}/seqtk 2>&1", 1)
  end
end

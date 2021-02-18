class Kmacs < Formula
  desc "K Mismatch Average Common Substring Approach"
  homepage "http://kmacs.gobics.de/"
  url "http://kmacs.gobics.de/content/kmacs.tar.gz"
  version "20140605"
  sha256 "39330272fa3436717a240270c35850caf2a65f4a1f395fabeb79c4802d9594fe"
  bottle do
    sha256 cellar: :any_skip_relocation, el_capitan:   "74a1d8ec162cc13f341d016d243651c8c1cd164e96254cf54f280992caad9970"
    sha256 cellar: :any_skip_relocation, yosemite:     "8af8df33d1b57160b4d571025c50fda29e1b5e5a4a7ac4199a7bd693b70c0bba"
    sha256 cellar: :any_skip_relocation, mavericks:    "46d83a1535dacc9111701b5db92399f408a93c2d2e43d8f5480266d3566e594d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8b3a54490328683a8d6c6283aa8ca029d009955a82a758c63aec3f3f3fbfa997"
  end

  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu331"

  def install
    system "make"
    bin.install "kmacs"
    doc.install "README"
  end

  test do
    assert_match "file.fasta k", shell_output("#{bin}/kmacs 2>&1", 1)
  end
end

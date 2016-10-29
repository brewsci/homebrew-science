class Kmacs < Formula
  desc "k Mismatch Average Common Substring Approach"
  homepage "http://kmacs.gobics.de/"
  bottle do
    cellar :any_skip_relocation
    sha256 "74a1d8ec162cc13f341d016d243651c8c1cd164e96254cf54f280992caad9970" => :el_capitan
    sha256 "8af8df33d1b57160b4d571025c50fda29e1b5e5a4a7ac4199a7bd693b70c0bba" => :yosemite
    sha256 "46d83a1535dacc9111701b5db92399f408a93c2d2e43d8f5480266d3566e594d" => :mavericks
    sha256 "8b3a54490328683a8d6c6283aa8ca029d009955a82a758c63aec3f3f3fbfa997" => :x86_64_linux
  end

  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu331"

  url "http://kmacs.gobics.de/content/kmacs.tar.gz"
  version "20140605"
  sha256 "39330272fa3436717a240270c35850caf2a65f4a1f395fabeb79c4802d9594fe"

  def install
    system "make"
    bin.install "kmacs"
    doc.install "README"
  end

  test do
    assert_match "file.fasta k", shell_output("#{bin}/kmacs 2>&1", 1)
  end
end

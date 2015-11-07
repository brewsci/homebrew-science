class Minimap < Formula
  desc "Find approx mapping positions between long sequences"
  homepage "https://github.com/lh3/minimap"
  # tag "bioinformatics"

  url "https://github.com/lh3/minimap/archive/v0.1.tar.gz"
  sha256 "56439c1c0385456affd1c440687a73adab90acdeb9ab721fa237d547c57eb0e2"

  head "https://github.com/lh3/minimap.git"

  def install
    system "make"
    bin.install "minimap"
  end

  test do
    assert_match "mapping", shell_output("#{bin}/minimap 2>&1", 1)
  end
end

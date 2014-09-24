require "formula"

class Tabtk < Formula
  homepage "https://github.com/lh3/tabtk"
  url "https://github.com/lh3/tabtk/archive/7109d8b.tar.gz"
  sha1 "cd75b63a91a1d3d7e1f2c7929fb6e58d8bddfa91"
  version "2014-09-22-r9"

  def install
    system "make"
    bin.install "tabtk"
    doc.install "README.md"
  end

  test do
    system "tabtk 2>&1 |grep -q tabtk"
  end
end

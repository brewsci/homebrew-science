require "formula"

class Tabtk < Formula
  homepage "https://github.com/lh3/tabtk"
  url "https://github.com/lh3/tabtk.git", :revision => "3ac8bb90"
  version "2014-09-13-r7"

  def install
    system "make"
    bin.install "tabtk"
    doc.install "README.md"
  end

  test do
    system "tabtk 2>&1 |grep -q tabtk"
  end
end

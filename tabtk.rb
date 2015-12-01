class Tabtk < Formula
  homepage "https://github.com/lh3/tabtk"
  url "https://github.com/lh3/tabtk/archive/7109d8b.tar.gz"
  sha256 "8d2f92a4ef22e07984f927cfbf65ac9c54a379e58d18613e56ba763e92a9ed90"
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

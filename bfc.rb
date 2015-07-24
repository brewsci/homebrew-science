class Bfc < Formula
  homepage "https://github.com/lh3/bfc"
  # doi "10.1093/bioinformatics/btv290"
  # tag "bioinformatics"

  url "https://github.com/lh3/bfc/archive/submitted-v1.tar.gz"
  version "175"
  sha1 "50fdbf2751c1fb94e6ef660774f93be1d3a13ae3"
  head "https://github.com/lh3/bfc.git"

  bottle do
    cellar :any
    sha1 "4c85ff047fca62de9e3646aacd39c06e693f3078" => :yosemite
    sha1 "7e55239986b9e61182f1517e2eacc65f6e794406" => :mavericks
    sha1 "b010673d74808cca9da124e1e0792a4e1fb19e4e" => :mountain_lion
  end

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    system "#{bin}/bfc", "-v"
  end
end

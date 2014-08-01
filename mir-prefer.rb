require "formula"

class MirPrefer < Formula
  homepage "https://github.com/hangelwen/miR-PREFeR"
  head "https://github.com/hangelwen/miR-PREFeR.git"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.19.tar.gz"
  sha1 "af70c5ea4c68d0918c61259b7ce8c1658e511a17"

  depends_on "samtools"
  depends_on "viennarna"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../miR_PREFeR.py"
  end

  test do
    system "python #{bin}/miR_PREFeR.py -h"
  end
end

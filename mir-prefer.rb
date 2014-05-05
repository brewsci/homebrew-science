require "formula"

class MirPrefer < Formula
  homepage "https://github.com/hangelwen/miR-PREFeR"
  head "https://github.com/hangelwen/miR-PREFeR.git"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.16.tar.gz"
  sha1 "19e5d81f9a1f448d4eff564ac25f9ba3aaab3b70"

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

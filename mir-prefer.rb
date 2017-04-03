class MirPrefer < Formula
  desc "MicroRNA prediction from small RNA-seq data"
  homepage "https://github.com/hangelwen/miR-PREFeR"
  # doi "10.1093/bioinformatics/btu380"
  # tag "bioinformatics"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.24.tar.gz"
  sha256 "457545478e2d3bc7497d350f3972cf0855b82fa7cb0263a6d91756732f487faf"
  head "https://github.com/hangelwen/miR-PREFeR.git"

  depends_on "samtools"
  depends_on "viennarna"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../miR_PREFeR.py"
  end

  test do
    system "python", "#{bin}/miR_PREFeR.py", "-h"
  end
end

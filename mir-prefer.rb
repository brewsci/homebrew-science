class MirPrefer < Formula
  homepage "https://github.com/hangelwen/miR-PREFeR"
  head "https://github.com/hangelwen/miR-PREFeR.git"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.19.tar.gz"
  sha256 "e71baa5b8ed3db89e4bf15ecbe639ee2116dc7328d75b92e49829240f75c9daa"
  # doi "10.1093/bioinformatics/btu380"
  # tag "bioinformatics"

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

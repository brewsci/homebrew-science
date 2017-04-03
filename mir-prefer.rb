class MirPrefer < Formula
  desc "MicroRNA prediction from small RNA-seq data"
  homepage "https://github.com/hangelwen/miR-PREFeR"
  # doi "10.1093/bioinformatics/btu380"
  # tag "bioinformatics"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.24.tar.gz"
  sha256 "457545478e2d3bc7497d350f3972cf0855b82fa7cb0263a6d91756732f487faf"
  head "https://github.com/hangelwen/miR-PREFeR.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a5e4e1bc3293170a2b76b7edb706e4330aee2af5f35344d6ea0e77adb7ebce9" => :sierra
    sha256 "adad9852553b173f5ac03de1741ecf2338d4233f800acf8056b6a3d94c199497" => :el_capitan
    sha256 "adad9852553b173f5ac03de1741ecf2338d4233f800acf8056b6a3d94c199497" => :yosemite
  end

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

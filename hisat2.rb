class Hisat2 < Formula
  desc "graph-based alignment to a population of genomes"
  homepage "http://ccb.jhu.edu/software/hisat2/"
  # tag "bioinformatics"

  url "ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.1-beta-source.zip"
  sha256 "0203f84abef4a3af92b53e070bee2da2d1ebab7570dedab432dcc0a11c051824"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc8a866e18b67585464832a29aec21a3ea19436cdf1ff4556f5fa8b13eb34199" => :el_capitan
    sha256 "8b12600369048b3c7d76fc08e6a979eec25f34eb6fb0a0b3a0ca6449cf2b663a" => :yosemite
    sha256 "08f7959046599d826605329b4a1b8c89f6efe64193a0ab85c3ce3edd0c655f36" => :mavericks
  end

  def install
    system "make"
    bin.install "hisat2", Dir["hisat2-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "HISAT2", shell_output("hisat2 2>&1", 1)
  end
end

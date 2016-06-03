class Hisat2 < Formula
  desc "graph-based alignment to a population of genomes"
  homepage "http://ccb.jhu.edu/software/hisat2/"
  # tag "bioinformatics"

  url "ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.1-beta-source.zip"
  sha256 "0203f84abef4a3af92b53e070bee2da2d1ebab7570dedab432dcc0a11c051824"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1ec8f813add57678fd30638d5f06e9b6c23d6bb1d46f7d040f4c893ca0b1c84" => :el_capitan
    sha256 "fdb6a45ba3f6ef5902ab1c340277c448b70279d9ddf485a1e3a51cc310edfd4e" => :yosemite
    sha256 "853345f116daf23c4b6ea5dae1bab4a3559d8c32e763c49f929ed1e4a0f4a7db" => :mavericks
    sha256 "ebdfe7bee0d774749fe726c3da2061f052bd13c9e6ae0a5fc9ac20cb6046dd3c" => :x86_64_linux
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

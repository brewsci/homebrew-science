class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.3.tar.gz"
  sha256 "c01b16a681dc55f114dbfc2fcd725f615b2d9a79058ff8c110047cfa9cbe2976"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4d882fcf75d0a17434834df2006526e6474c689d6a5ec129e4622af22457257" => :sierra
    sha256 "65bf922dbb1ff8ee9df0b52c116c345ea056b3c17f326e398cf0d06e9b620710" => :el_capitan
    sha256 "97361a509577b7b1a9ebb1c5211daeb870c28f1a372a8b5353ea2049ae6c3ffa" => :yosemite
  end

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end

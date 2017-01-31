class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.2d.tar.gz"
  sha256 "6e952b7bab6c5da79c751e79541819245ece2bdad9d5d707551119c30f0ccd66"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "f72ec6fa67820a7d7e0977630b9b8a4f51836552126a64af0d15fd15100944f4" => :sierra
    sha256 "75f3adcb32016da623fa9c93c2c0c1da0df7a3e54dc985b37e9f6069009477b9" => :el_capitan
    sha256 "4d9a66cab9fee4477efa0ad010d3ed17c94c1cfff4495c9e7fe00f2f46dbc346" => :yosemite
  end

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end

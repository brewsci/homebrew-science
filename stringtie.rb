class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.1c.tar.gz"
  sha256 "69fc957efd1832ec62640f7b4a78c052e565574f73deea93f90eb20a061f147d"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "64591866359f9288ae75f104c70b916867df1347fd19782a4988827d890b0c4c" => :sierra
    sha256 "acb7009fc22e8ca345d55be846bc50a64de22996cbe9f8d6ff8f4efddfb26417" => :el_capitan
    sha256 "babd6585016cd53ddc9be7fd44f1213a3ef5221a0379717ac7988ea4086ea1b2" => :yosemite
    sha256 "d3b47ac5e85a356649d7036e11d65cb760b6bbc640599c6a66b3b3615f8cc4a5" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end

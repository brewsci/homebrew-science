class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/5e1e8dbd506ea1ff8c77d468a1f27b8e8f73eac0.tar.gz"
  version "82"
  sha256 "dd4b54a3ba57279659153204aa59aa1d5efe4d307549ac7b8e93b67eb9d3248f"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    cellar :any
    sha256 "a0a7413764b47a974bed1dd7421aae2955a20be5472ca8eb50115e851abed8ba" => :yosemite
    sha256 "df87383935ec546aff0f7d4583994f0cf17f308eaf238f3c4ac3fa6d76ca824f" => :mavericks
    sha256 "4b1189e67b37d36feaf8e58cc6002012db347cd594895be0bcb84b99cfd322be" => :mountain_lion
  end

  def install
    system "make"
    bin.install "seqtk"
    doc.install "README.md"
  end

  test do
    assert_match "seqtk", shell_output("#{bin}/seqtk 2>&1", 1)
  end
end

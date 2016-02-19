class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/5e1e8dbd506ea1ff8c77d468a1f27b8e8f73eac0.tar.gz"
  version "82"
  sha256 "dd4b54a3ba57279659153204aa59aa1d5efe4d307549ac7b8e93b67eb9d3248f"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80347faabb214b4a035f9c435be6a4ccbc70142d4a5b593f5c37115f9217ea9b" => :el_capitan
    sha256 "a08757a2d6b5de72f5ab0f08e48457006d621fdcd57b4ce7976e2ed88fc6432e" => :yosemite
    sha256 "6146557f07f725bbe985fb308b7be5b9839bf513db3b4ca63c9a90f37da2e48a" => :mavericks
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

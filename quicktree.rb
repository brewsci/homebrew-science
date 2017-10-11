class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/resources/software/quicktree/"

  url "https://github.com/khowe/quicktree/archive/v2.1.tar.gz"
  sha256 "5e2d7687578c9489a8b6ad026444dfb56e322a1fb8177feee9fcdc66328a0684"

  head "https://github.com/khowe/quicktree.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e5fc6dfd9189adec6fd97204dc4e5ef2d00ef05f4eb3e7819bb918855c0a9c6" => :sierra
    sha256 "22d08b0f4bbbcc1f92b2b8eb358155b2551ad4f3d344f3557b9b1ecd8eda0501" => :el_capitan
    sha256 "be3f595c268ff391ccd1351f8d91b5f09eb45e819630533f107c52d6d5b32846" => :yosemite
    sha256 "7654424e618179f3f4a0efd269edc37c582f64523c7103645e5ab2eaf65a51fe" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "quicktree"
  end

  test do
    assert_match "UPGMA", shell_output("#{bin}/quicktree -h 2>&1", 0)
  end
end

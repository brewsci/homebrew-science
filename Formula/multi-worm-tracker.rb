class MultiWormTracker < Formula
  desc "Multi-Worm Tracker: analyzes moving objects"
  homepage "https://sourceforge.net/projects/mwt/"
  # doi "10.1038/nmeth.1625"
  # tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/mwt/MWT_latest_1.3.0_r1035.zip"
  version "1.3.0"
  sha256 "4f57f83314a14c74b1e463b5a2f9f495687da02b803e3b62a1af1ead09b57797"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a085b8be54b5a51e2a8971fb4f095a6d26dfd7d2c5dad753ec6c6d68abb19ab" => :yosemite
    sha256 "a6294aad75e06433796ec033bf811de62c9509f697aa50446bbcaf89a9e2181b" => :mavericks
    sha256 "98d60693f2466afcfb92c50c7f537f17bfa13484bc1f257907306c54c999ca93" => :mountain_lion
    sha256 "74dc7a28cf58321c0431548434378d4fc8285bea3dac45477c2749226698227f" => :x86_64_linux
  end

  depends_on :java

  def install
    prefix.install Dir["*"]
    bin.write_jar_script prefix/"analysis/Chore.jar", "Chore", "$MWT_JAVA_OPTIONS"
  end

  test do
    assert_match "Usage", shell_output(bin/"Chore", 1)
  end
end

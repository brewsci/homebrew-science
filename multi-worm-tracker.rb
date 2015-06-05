class MultiWormTracker < Formula
  desc "Multi-Worm Tracker: analyzes moving objects"
  homepage "http://sourceforge.net/projects/mwt/"
  # doi "10.1038/nmeth.1625"
  # tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/mwt/MWT_latest_1.3.0_r1035.zip"
  version "1.3.0"
  sha256 "4f57f83314a14c74b1e463b5a2f9f495687da02b803e3b62a1af1ead09b57797"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "2d4997151063d70183eb96cfe013a881f86245621d058aa55ee55c45367975c2" => :yosemite
    sha256 "cfd9ceb23080745ddfc6654e80363aca510ea3df490e1f3b91860f2bb06d5c07" => :mavericks
    sha256 "70b5cb33a50031c0c8d6eb56b5e4bcf8b8fff3996aa4c509bfef76f3d8e44f8b" => :mountain_lion
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

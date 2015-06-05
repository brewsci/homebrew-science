class MultiWormTracker < Formula
  desc "Multi-Worm Tracker: analyzes moving objects"
  homepage "http://sourceforge.net/projects/mwt/"
  # doi "10.1038/nmeth.1625"
  # tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/mwt/MWT_latest_1.3.0_r1035.zip"
  version "1.3.0"
  sha256 "4f57f83314a14c74b1e463b5a2f9f495687da02b803e3b62a1af1ead09b57797"
  depends_on :java

  def install
    prefix.install Dir["*"]
    bin.write_jar_script prefix/"analysis/Chore.jar", "Chore"
  end

  test do
    assert_match "Usage", shell_output(bin/"Chore", 1)
  end
end

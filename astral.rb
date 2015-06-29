class Astral < Formula
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  # doi "10.1093/bioinformatics/btu462"
  # tag "bioinformatics"

  url "https://github.com/smirarab/ASTRAL/raw/master/Astral.4.7.8.zip"
  sha256 "5761b8e25b1417ee72ddc0658c02e587d4e84c53e99564aca62a793b1736d289"

  # head "https://github.com/smirarab/ASTRAL.git"

  depends_on :java

  def install
    (share/"astral").install Dir["*"]
    bin.write_jar_script share/"astral/astral.#{version}.jar", "astral"
  end

  test do
    system "astral", "-i", share/"astral/test_data/trivial.tre"
  end
end

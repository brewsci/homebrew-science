class Astral < Formula
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "fd942a7f95f5af65cf37b664711b0c163709b344c600e9b54549fe3ed34aab8d" => :yosemite
    sha256 "fd942a7f95f5af65cf37b664711b0c163709b344c600e9b54549fe3ed34aab8d" => :mavericks
    sha256 "9abe785b08c07bfbb746cd5f3a78c2f3f4b6071fb0698f4e80cc4ae30e94a879" => :mountain_lion
  end

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

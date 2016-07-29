class Astral < Formula
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  # doi "10.1093/bioinformatics/btu462"
  # tag "bioinformatics"

  url "https://github.com/smirarab/ASTRAL/archive/v4.10.7.tar.gz"
  sha256 "314b49e0129ec06a7c78a1b60d590259ede6a5e75253407031e108d8048fcc79"

  # head "https://github.com/smirarab/ASTRAL.git"

  bottle :unneeded

  depends_on :java
  depends_on "homebrew/dupes/unzip" => :build unless OS.mac?

  def install
    safe_system "unzip", "Astral.#{version}.zip"
    pkgshare.install "lib", "main", "Astral/astral.#{version}.jar"

    bin.write_jar_script pkgshare/"astral.#{version}.jar", "astral"
  end

  test do
    system bin/"astral", "-i", pkgshare/"main/test_data/simulated_14taxon.gene.tre"
  end
end

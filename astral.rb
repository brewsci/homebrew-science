class Astral < Formula
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  # doi "10.1093/bioinformatics/btu462"
  # tag "bioinformatics"

  url "https://github.com/smirarab/ASTRAL/archive/v4.7.12.tar.gz"
  sha256 "393f520a168f1c9e0b8499177726c90fbd09494c64c03899cd6628f9497391a6"

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

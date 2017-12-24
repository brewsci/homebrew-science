class Astral < Formula
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  # doi "10.1093/bioinformatics/btu462"
  # tag "bioinformatics"

  url "https://github.com/smirarab/ASTRAL/archive/5.5.6.tar.gz"
  sha256 "dc7d6b09a15db7ebdc676f354b3e3300beba8bf104c4366a61f31535044b58b7"

  # head "https://github.com/smirarab/ASTRAL.git"

  bottle :unneeded

  depends_on :java
  depends_on "unzip" => :build unless OS.mac?

  def install
    safe_system "unzip", "Astral.#{version}.zip"
    pkgshare.install "lib", "main", "Astral/astral.#{version}.jar"

    bin.write_jar_script pkgshare/"astral.#{version}.jar", "astral"
  end

  test do
    system bin/"astral", "-i", pkgshare/"main/test_data/simulated_14taxon.gene.tre"
  end
end

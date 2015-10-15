class Astral < Formula
  desc "Estimate species tree given set of unrooted gene trees"
  homepage "https://github.com/smirarab/ASTRAL"
  # doi "10.1093/bioinformatics/btu462"
  # tag "bioinformatics"

  url "https://github.com/smirarab/ASTRAL/raw/master/Astral.4.7.8.zip"
  sha256 "5fb6eb0f899d29f2c23aefdd529a2fd2c3d069bb13fed87e381aeb48650cd4c9"

  # head "https://github.com/smirarab/ASTRAL.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3df52b0460d1f9ae3a0a00007a89615e4f540e94b60a6d27aa6fea9b00104ca3" => :el_capitan
    sha256 "947ddf4a3754661849cf712b18e547cde215198d81c92137927cdbaa8c6e1de0" => :yosemite
    sha256 "18611c4aeb688d563222163ea42b4e59b4ed31c763c0dfdaa54b1b22bb824aef" => :mavericks
  end

  depends_on :java

  def install
    pkgshare.install Dir["*"]
    bin.write_jar_script pkgshare/"astral.#{version}.jar", "astral"
  end

  test do
    system "astral", "-i", pkgshare/"test_data/trivial.tre"
  end
end

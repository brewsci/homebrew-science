class Snpeff < Formula
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "http://snpeff.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.4161/fly.19695"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1l_core.zip"
  version "4.1l"
  revision 2
  sha256 "1d5b2831c631a175b88bac57aefddea6f79588ef2ccbac8505f66e0961e54bf5"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfb7757c173a7565a0c7f0c6331fb6a6c9385b4a8e46a8f12f057e45a9dab844" => :el_capitan
    sha256 "ad019bfc66c455a4e596d9f454e3fd21dd91f38fd52e79a4d7fe474da18cb6a4" => :yosemite
    sha256 "2b3f6e9d9befd1312ea04883c9c845fbdd4990ae56b4d531a3311bfb23fd6e1e" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    inreplace "scripts/snpEff" do |s|
      s.gsub! /^jardir=.*/, "jardir=#{libexec}"
      s.gsub! "${jardir}/snpEff.config", "#{pkgshare}/snpEff.config"
    end

    bin.install "scripts/snpEff"
    libexec.install "snpEff.jar", "SnpSift.jar"
    bin.write_jar_script libexec/"SnpSift.jar", "SnpSift"
    pkgshare.install "snpEff.config", "scripts", "galaxy"
  end

  def caveats; <<-EOS.undent
      Download the human database using the command
          snpEff download -v GRCh38.76
      The databases will be installed in #{pkgshare}/data
    EOS
  end

  test do
    system "#{bin}/snpEff 2>&1 |grep -q snpEff"
    system "#{bin}/SnpSift 2>&1 |grep -q extractFields"
  end
end

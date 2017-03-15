class Snpeff < Formula
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "https://snpeff.sourceforge.io/"
  # tag "bioinformatics"
  # doi "10.4161/fly.19695"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_3i_core.zip"
  version "4.3i"
  sha256 "ebd3d5bec106c3ebc68961b941d3420c44fe1febe4654eb2931eb100c4a33a44"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9ebb430ee2bcc71831ce17889447b097c5f501a0d3b240d59fb3fed255d962" => :sierra
    sha256 "2e9ebb430ee2bcc71831ce17889447b097c5f501a0d3b240d59fb3fed255d962" => :el_capitan
    sha256 "2e9ebb430ee2bcc71831ce17889447b097c5f501a0d3b240d59fb3fed255d962" => :yosemite
    sha256 "ae791f614cde0602d42da9c83cc352d143982bef4e5119ec497f58831a9a17ef" => :x86_64_linux
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
          snpEff download -v GRCh38.82
      The databases will be installed in #{pkgshare}/data
    EOS
  end

  test do
    system "#{bin}/snpEff 2>&1 |grep -q snpEff"
    system "#{bin}/SnpSift 2>&1 |grep -q extractFields"
  end
end

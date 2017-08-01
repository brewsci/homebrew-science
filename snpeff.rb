class Snpeff < Formula
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "https://snpeff.sourceforge.io/"
  # tag "bioinformatics"
  # doi "10.4161/fly.19695"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_3p_core.zip"
  version "4.3p"
  sha256 "61f52d2105230ddf74ca810062b6b98473515fa403012cb8fd6498d63d9863f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9ebb430ee2bcc71831ce17889447b097c5f501a0d3b240d59fb3fed255d962" => :sierra
    sha256 "2e9ebb430ee2bcc71831ce17889447b097c5f501a0d3b240d59fb3fed255d962" => :el_capitan
    sha256 "2e9ebb430ee2bcc71831ce17889447b097c5f501a0d3b240d59fb3fed255d962" => :yosemite
    sha256 "ae791f614cde0602d42da9c83cc352d143982bef4e5119ec497f58831a9a17ef" => :x86_64_linux
  end

  depends_on :java => "1.8+"

  def install
    # snpEff and SnpSift
    cd "snpEff" do
      inreplace "scripts/snpEff" do |s|
        s.gsub! /^jardir=.*/, "jardir=#{libexec}"
        s.gsub! "${jardir}/snpEff.config", "#{pkgshare}/snpEff.config"
      end
      bin.install "scripts/snpEff"
      libexec.install "snpEff.jar", "SnpSift.jar"
      bin.write_jar_script libexec/"SnpSift.jar", "SnpSift"
      pkgshare.install "snpEff.config", "scripts", "galaxy", "examples"
    end

    # ClinEff
    cd "clinEff" do
      libexec.install "ClinEff.jar"
      bin.write_jar_script libexec/"ClinEff.jar", "ClinEff"
      pkgshare.install "workflow", "report"
    end
  end

  def caveats; <<-EOS.undent
      Download the human database using the command
          snpEff download -v GRCh38.82
      The databases will be installed in #{pkgshare}/data
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snpEff -version 2>&1")
    assert_match "Concordance", shell_output("#{bin}/SnpSift 2>&1", 1)
    assert_match "annotations", shell_output("#{bin}/ClinEff -h 2>&1", 255)
  end
end

class Snpeff < Formula
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "http://snpeff.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.4161/fly.19695"
  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1k_core.zip"
  version "4.1k"
  sha256 "45d79b829f463028986cf22f00f70665718d5f136515d2435c5fbf300322683a"

  bottle do
    cellar :any
    revision 1
    sha256 "2c6e9f12378588d0ea09b270fe39b2b7f2c6c673db3e7d7be94575be76c9d721" => :yosemite
    sha256 "7644372e72ccaa446192b4fcf883f1b8d218955660b4b9c839e67631994b8d13" => :mavericks
    sha256 "9d67ed82b345a0e6aa4256e7d675d52b4cbe88ae3a0996552114bb3e37f300ef" => :mountain_lion
  end

  depends_on :java => "1.7+"

  def install
    inreplace "scripts/snpEff" do |s|
      s.gsub! /^jardir=.*/, "jardir=#{libexec}"
      s.gsub! "${jardir}/snpEff.config", "#{pkgshare}/snpEff.config"
    end

    bin.install "scripts/snpEff"
    libexec.install "snpEff.jar", "SnpSift.jar"
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
  end
end

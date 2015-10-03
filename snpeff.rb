class Snpeff < Formula
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "http://snpeff.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.4161/fly.19695"
  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1l_core.zip"
  version "4.1l"
  sha256 "1d5b2831c631a175b88bac57aefddea6f79588ef2ccbac8505f66e0961e54bf5"

  bottle do
    cellar :any_skip_relocation
    sha256 "164788a5d3be7c0bc11c0235045e213ba09f18439b29756b8704c26f65fd4954" => :el_capitan
    sha256 "ca67c2307eba57330dfa70ccd4ee544797e279f496dedb56ed7f582e89576325" => :yosemite
    sha256 "79d65e0c47d7358b99a8ba370088d80a4a9278795da087e1069cd335e97e67cf" => :mavericks
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

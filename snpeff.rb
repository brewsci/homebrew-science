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
    sha256 "7e1240accda524f400455099e1a59be38e50406956950fc8f5a0a5386da38dcb" => :el_capitan
    sha256 "b32df65f919ec16c6dbd03e92389fbd77057af0a524c5760b38c05ae72b9d807" => :yosemite
    sha256 "b75df4da61eb5839985552c9c3ba122f6afdfe335556eea57f5cd0357edde8be" => :mavericks
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

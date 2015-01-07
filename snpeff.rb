require 'formula'

class Snpeff < Formula
  homepage 'http://snpeff.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/snpeff/snpEff_v4_0_core.zip'
  version '4.0e'
  sha1 '969fa41cd774a33629f63938f665ba1f83f9adcc'

  def install
    inreplace "scripts/snpEff" do |s|
      s.gsub! /^jardir=.*/, "jardir=#{libexec}"
      s.gsub! "${jardir}/snpEff.config", "#{share}/snpEff.config"
    end

    bin.install "scripts/snpEff"
    libexec.install "snpEff.jar", "SnpSift.jar"
    share.install "snpEff.config", "scripts", "galaxy"
  end

  def caveats; <<-EOS.undent
      Download the human database using the command
          snpEff download -v GRCh38.76
      The databases will be installed in #{share}/data
    EOS
  end

  test do
    system "#{bin}/snpEff 2>&1 |grep -q snpEff"
  end
end

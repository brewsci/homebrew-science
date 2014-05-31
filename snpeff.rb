require 'formula'

class Snpeff < Formula
  homepage 'http://snpeff.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/snpeff/snpEff_v3_6_core.zip'
  version '3.6c'
  sha1 'f4848e977f0818e5f221e0b07231fe0735864dd5'

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
          snpEff download -v GRCh37.75
      The databases will be installed in #{share}/data
    EOS
  end

  test do
    system "#{bin}/snpEff 2>&1 |grep -q snpEff"
  end
end

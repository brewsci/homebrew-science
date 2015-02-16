class Snpeff < Formula
  homepage "http://snpeff.sourceforge.net/"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1b_core.zip"
  version "4.1b"
  sha1 "dcc5fa17d84ea42a8b1f0da01e7038068d2a47dd"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3bd4246c5ab5383b232c7a0d7aa30a626bd90630" => :yosemite
    sha1 "de66508049a8e8d945399560557d34179dadb8fd" => :mavericks
    sha1 "a0a3c069ef8971d8799f3dfb119ac317be64f757" => :mountain_lion
  end

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

class Snpeff < Formula
  homepage "http://snpeff.sourceforge.net/"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1c_core.zip"
  version "4.1c"
  sha256 "93202eb4a42c18d1a13230a2661eb0d55fd50555462dd4a980d8293294a9496e"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "bb74b43f2915d2411b736a2634df7d067ca2e8a21ba6f2b7db20dffc108fd448" => :yosemite
    sha256 "2837819766c36310cf3644f56cd35474f5b9ff026ea52642034d77b866782c4c" => :mavericks
    sha256 "1473f06c20fb1554866bce64d40dcede198dbbab32aee4ad2c6c8ddae8fd7ef1" => :mountain_lion
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

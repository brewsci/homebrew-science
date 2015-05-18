class Snpeff < Formula
  homepage "http://snpeff.sourceforge.net/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1g_core.zip"
  version "4.1g"
  sha256 "c8528928f5f206d5bb6003f0ef12e50c40d84cd69d3c2dff21df9f93704e2ca0"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "ccbeeb69dc15af0e5fd9e951a7a7a5268065e86a6d04fc0f687f9b865f9713e9" => :yosemite
    sha256 "695f0dd0f5fc4e557c79ccbc4b73a39521279c04e2df5043470863733d3a33fc" => :mavericks
    sha256 "4aca12e9fbbf6ee3266cd0133d02bdbac5e2e45e356650f63e527df36f11e5e9" => :mountain_lion
  end

  depends_on :java => "1.7+"

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

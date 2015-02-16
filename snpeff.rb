class Snpeff < Formula
  homepage "http://snpeff.sourceforge.net/"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1b_core.zip"
  version "4.1b"
  sha1 "dcc5fa17d84ea42a8b1f0da01e7038068d2a47dd"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8a27c603167bb053bead21c418890afa403402c9" => :yosemite
    sha1 "c6d79130b58463e2260611d38815937bb444a328" => :mavericks
    sha1 "2dddec9434204d1f43141f2f9dbe17a2c8299a6e" => :mountain_lion
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

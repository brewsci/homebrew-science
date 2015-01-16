class Snpeff < Formula
  homepage "http://snpeff.sourceforge.net/"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1_core.zip"
  version "4.1a"
  sha1 "ed4460b89bc22cd6873d1ca6a3cde8565bd2f8d8"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3af04ac27e8a99988ba40429e220f547a2afda04" => :yosemite
    sha1 "66fcc5f9083b35a745347cc98fa17b5fb3da3f3a" => :mavericks
    sha1 "b32d1ccdd19b7a14231b3d24fc0ea2b89a6e448e" => :mountain_lion
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

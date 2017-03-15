class Snpeff < Formula
  desc "Genetic variant annotation and effect prediction toolbox"
  homepage "https://snpeff.sourceforge.io/"
  # tag "bioinformatics"
  # doi "10.4161/fly.19695"

  url "https://downloads.sourceforge.net/project/snpeff/snpEff_v4_3i_core.zip"
  version "4.3i"
  sha256 "ebd3d5bec106c3ebc68961b941d3420c44fe1febe4654eb2931eb100c4a33a44"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0103663f65d35f02fc49c38201947bfd11b0dcd9fab2eb33f9cb90c0724f064" => :el_capitan
    sha256 "740d12347a796f3f09419adf61a0d348684cd877a4ca079059dcb3135fc20664" => :yosemite
    sha256 "5fee025eae06b67c9eeb3e09a2105edf4e01eb7126216761183cfd0ef54d5266" => :mavericks
    sha256 "e349272665f4be6cb103b9b27c6e5bd366ef6d3735fa2543bff013be3c1606d3" => :x86_64_linux
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
          snpEff download -v GRCh38.82
      The databases will be installed in #{pkgshare}/data
    EOS
  end

  test do
    system "#{bin}/snpEff 2>&1 |grep -q snpEff"
    system "#{bin}/SnpSift 2>&1 |grep -q extractFields"
  end
end

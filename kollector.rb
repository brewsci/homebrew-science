class Kollector < Formula
  desc "Targeted de novo gene assembly"
  homepage "https://github.com/bcgsc/kollector"
  url "https://github.com/bcgsc/kollector/archive/V1.0.tar.gz"
  sha256 "76dc3e03398ade0ae39b241943ce7dabcf65c09e3b30180726bfea574c462d15"
  head "https://github.com/bcgsc/kollector.git"
  # tag "bioinformatics"

  depends_on "abyss"
  depends_on "biobloomtools"
  depends_on "bwa"
  depends_on "gmap-gsnap"
  depends_on "samtools"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "kollector.sh" => "kollector"
  end

  test do
    system "#{bin}/kollector", "-h"
  end
end

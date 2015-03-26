class Freec < Formula
  homepage "http://bioinfo.curie.fr/projects/freec/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"
  url "http://bioinfo.curie.fr/projects/freec/src/FREEC_Linux64.tar.gz"
  sha256 "dd8c0768ea0ed5bd36169fa68f9a3f48dd6f15889b9a60c7977b27bdb6da995d"
  version "7.2"

  def install
    # FAQ #20 Mac OS X building: http://bioinfo.curie.fr/projects/freec/FAQ.html
    if OS.mac?
      inreplace "myFunc.cpp", "values.h", "limits.h"
    end
    system "make"
    bin.install "freec"
  end

  test do
    assert_match "FREEC v#{version}", shell_output("freec 2>&1")
  end
end

class Freec < Formula
  homepage "http://bioinfo.curie.fr/projects/freec/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"
  url "http://bioinfo.curie.fr/projects/freec/src/FREEC_Linux64.tar.gz"
  sha256 "dd8c0768ea0ed5bd36169fa68f9a3f48dd6f15889b9a60c7977b27bdb6da995d"
  version "7.2"

  bottle do
    cellar :any
    sha256 "af7558fda0442a9c242abeb6a9492d82926197f14b31b3e0059a067189e1ae93" => :yosemite
    sha256 "f02914ae0075e54a4378d771f9dd5a98aa67da035606040b707758f9ead7163d" => :mavericks
    sha256 "d7571b435829f2f7356cefdf542cd4563f5e0df038673ce201ab7237bc3ff73b" => :mountain_lion
  end

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

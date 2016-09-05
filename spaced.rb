class Spaced < Formula
  desc "Spaced-Words for alignment-free sequence comparison"
  homepage "http://spaced.gobics.de/"
  url "http://spaced.gobics.de/content/spaced.tar.gz"
  version "20160804"
  sha256 "016e9b565dc7189a69bd87e34b0df2f8a85831bd7f765b4f43b5612a2cff5fb1"
  # doi "10.1186/s13015-015-0032-x"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e788d0a55ed9021c4c64b5775b63bce95b6d2703a2a7491989c804bd86989b99" => :el_capitan
    sha256 "e2a00ae89014cbbcb3c1e1ef1d7b0320646faa19be2413af70acc77c2f4d9074" => :yosemite
    sha256 "807752981616621375d085b40475814ef58478127fb5717afe0ea7d99aa36b58" => :mavericks
  end

  needs :cxx11
  needs :openmp

  def install
    # Fix: error: 'default_random_engine' in namespace 'std' does not name a type
    inreplace "src/patternset.h", "#include <vector>", "#include <vector>\n#include <random>\n"
    system "make"
    bin.install "spaced"
    doc.install "README", "COPYING"
  end

  test do
    assert_match "Jensen-Shannon", shell_output("#{bin}/spaced 2>&1", 0)
  end
end

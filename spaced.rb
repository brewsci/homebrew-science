class Spaced < Formula
  desc "Spaced-Words for alignment-free sequence comparison"
  homepage "http://spaced.gobics.de/"
  # doi "10.1186/s13015-015-0032-x"
  # tag "bioinformatics"

  url "http://spaced.gobics.de/content/spaced.tar.gz"
  version "20160804"
  sha256 "016e9b565dc7189a69bd87e34b0df2f8a85831bd7f765b4f43b5612a2cff5fb1"

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

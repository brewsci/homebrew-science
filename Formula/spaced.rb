class Spaced < Formula
  desc "Spaced-Words for alignment-free sequence comparison"
  homepage "http://spaced.gobics.de/"
  url "http://spaced.gobics.de/content/spaced.tar.gz"
  version "20160804"
  sha256 "3edbd66dc14054d3001dbe3cb6dd4f437f4c6738e1f7d3393bfac9e444410215"
  revision 1
  # doi "10.1186/s13015-015-0032-x"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "226ae5554d19478f42ef93243edc23c51d8a14d392cf38ae4dc636cfe83fca77" => :sierra
    sha256 "c3c437713efc321bf373579effdbdfe41f180310555dcee9f3255dc0909eab5f" => :el_capitan
    sha256 "081b68362c87edd54abe102fdcc0b6f8b48f2c1512d653501332529875014e83" => :yosemite
    sha256 "6362837ffb2f8bd05dda5e1b1c4af1ef42bf3838bb9aa3d0e1dd8aaf3c7329bf" => :x86_64_linux
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

class Muscle < Formula
  homepage "http://www.drive5.com/muscle/"
  # doi "10.1093/nar/gkh340", "10.1186/1471-2105-5-113"
  # tag "bioinformatics"

  url "http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz"
  version "3.8.31"
  sha256 "43c5966a82133bd7da5921e8142f2f592c2b5f53d802f0527a2801783af809ad"

  bottle do
    cellar :any
    revision 1
    sha256 "0a990ee3f64ded25220d31a433c042bcdba901a73dbece2ec9ada87922f63223" => :yosemite
    sha256 "8d13788647466efb841666a9c063cc464abf41fdb430b4b2cb20936bec74b4f3" => :mavericks
    sha256 "00f1fff48e1003d2e31a3868bd7360a4c2d2736bce3e398e6149dbce87bcf1de" => :mountain_lion
  end

  def install
    # This patch makes 3.8.31 build on OSX >= Lion.
    # It has been reported upstream but not fixed yet.
    inreplace "src/globalsosx.cpp",
              "#include <mach/task_info.h>",
              "#include <mach/vm_statistics.h>\n#include <mach/task_info.h>"

    # This patch makes 3.8.31 build on RHEL 7.x
    # It ONLY affects Linux (in an "if Linux" clause in the 'mk' script)
    # It is unnecessary to create a static binary
    inreplace "src/mk",
              "LINK_OPTS=-static",
              "LINK_OPTS="

    cd "src" do
      system "make"
      bin.install "muscle"
    end
  end
end

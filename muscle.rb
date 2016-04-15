class Muscle < Formula
  desc "Multiple sequence alignment program"
  homepage "http://www.drive5.com/muscle/"
  # doi "10.1093/nar/gkh340", "10.1186/1471-2105-5-113"
  # tag "bioinformatics"

  url "http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz"
  version "3.8.31"
  sha256 "43c5966a82133bd7da5921e8142f2f592c2b5f53d802f0527a2801783af809ad"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "095e948e36fbdcea5dce3aa55aa7a5aa76101d41e86306b15aa15f827c70eac3" => :el_capitan
    sha256 "2b4484979ad18f9cfaff6905925424666cdbb46972000cbd87155c24b27accd7" => :yosemite
    sha256 "c020974f146e0b5f35c16e79aa64c00b2cd06ea3ecd16d5f39e26c11318a2e45" => :mavericks
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

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle -version")
  end
end

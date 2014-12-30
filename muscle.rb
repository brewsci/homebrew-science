class Muscle < Formula
  homepage "http://www.drive5.com/muscle/"
  #doi "10.1093/nar/gkh340", "10.1186/1471-2105-5-113"
  #tag "bioinformatics"

  url "http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz"
  version "3.8.31"
  sha1 "2fe55db73ff4e7ac6d4ca692f8f213d1c5071dac"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "b29b1f47580ef76f031bc19d0edded75b17dc5ff" => :yosemite
    sha1 "08147f3f1f174c2d4e9c631dfbc2647d67a3cd6c" => :mavericks
    sha1 "8398248dcadcae5a753eae15630cb815d9b19cdc" => :mountain_lion
  end

  def install
    # This patch makes 3.8.31 build on OSX >= Lion.
    # It has been reported upstream but not fixed yet.
    inreplace "src/globalsosx.cpp",
              "#include <mach/task_info.h>",
              "#include <mach/vm_statistics.h>\n#include <mach/task_info.h>"

    cd "src" do
      system "make"
      bin.install "muscle"
    end
  end
end

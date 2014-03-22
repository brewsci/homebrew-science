require 'formula'

class Muscle < Formula
  homepage 'http://www.drive5.com/muscle/'
  url 'http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz'
  version '3.8.31'
  sha1 '2fe55db73ff4e7ac6d4ca692f8f213d1c5071dac'

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

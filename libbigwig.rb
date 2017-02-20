class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.3.0.tar.gz"
  sha256 "221002fe249e8099009f0790f44bfe991e85cb23763cf5fc494e745c0160edc2"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "42ecdb4ce86c0c36b8ee6cf7a051fa4e7883a5c75788646dd6543333be20cf8a" => :sierra
    sha256 "84b47d8d8be71bec626d67cffd0fb8703d1849e26a02bd4badd99c76734e0ad3" => :el_capitan
    sha256 "355801a6ac75813749d9a83b72d53c4ddd25b21457420f28cacec8510a35585f" => :yosemite
  end

  depends_on "curl"

  def install
    curl = Formula["curl"]
    system "make", "install", "prefix=#{prefix}", "INCLUDES=-I#{curl.opt_include}", "LDLIBS=-L#{curl.opt_lib}"
  end

  test do
    (testpath/"libbigwig.c").write <<-EOS.undent
    #include "bigWig.h"
    #include <stdio.h>
    #include <inttypes.h>
    #include <stdlib.h>

    int main(int argc, char *argv[]) {
      if(bwInit(1<<17) != 0) {
          return 1;
      }
      return 0;
    }
    EOS
    libs = %w[-lBigWig]
    system ENV.cc, "-o", "test", "libbigwig.c", "-I#{include}", "-L#{lib}", *libs
    system "./test"
  end
end

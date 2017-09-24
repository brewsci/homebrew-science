class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.4.1.tar.gz"
  sha256 "0dd6f52f6c73aaad5b00265d742bdaaf12b490cd3673fac74f80bcb661d4a591"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "64e4a4181fce9dbe5ed2997103e0f288345ec710479d57556813c6dc2dd0c485" => :high_sierra
    sha256 "e554998a6fda11b3094b4efcf0b34bca5671d0b34dd572a3fca2a2ecb4d6dd2b" => :sierra
    sha256 "ddd86b1f5d5faf976ce6d4aec9eed2d2b24f14a08e9a248b347284d72f16521a" => :el_capitan
    sha256 "1f33b86ca55247ed644a8310c75f773c8b9a5a507701e3433e3b2aef0cd97d97" => :x86_64_linux
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

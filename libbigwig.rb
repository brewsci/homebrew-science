class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.4.0.tar.gz"
  sha256 "ecf466c412819a1a0aa6c105d8b71481b90994cb8a6c028511c4617f0dc8f064"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "9ee6c71ba0dd5695c06ad1fb14eb45fe9b3af606c6c9be2ead46f697ebf9cc18" => :sierra
    sha256 "39e696991d1f165cb8245387a6879bab3f230792dcb8b16d0ded1a259bc6f6b4" => :el_capitan
    sha256 "d21ae1e55c07709232942e7f113a2afd0169fa109f594092217f759c267a1682" => :yosemite
    sha256 "c01ada078269cc06ad49c5289f72762837c4134287ec1c7147c4ce53e3b89d96" => :x86_64_linux
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

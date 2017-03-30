class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.3.3.tar.gz"
  sha256 "85b5c930bedf9eef84e44c8d4faec28bcffc74362ad56ac3d4321f0e1b532199"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "adf5d1e84f5fc696194caaa3a4f44902c35c69cb8a63f0c049e1bae786671bab" => :sierra
    sha256 "b1efca94cc405e840a50ef67f8737a0b4e4d195133b8cff57cf6a69ecf660b87" => :el_capitan
    sha256 "f5b1be46498fd1d89995d36e72a62ade524b00adab054ddbe4a440738f26033e" => :yosemite
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

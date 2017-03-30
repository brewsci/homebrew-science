class Libbigwig < Formula
  desc "C library for processing the big UCSC fomats"
  homepage "https://github.com/dpryan79/libBigWig"
  url "https://github.com/dpryan79/libBigWig/archive/0.3.3.tar.gz"
  sha256 "85b5c930bedf9eef84e44c8d4faec28bcffc74362ad56ac3d4321f0e1b532199"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "36f6af76053d6bd6effdcf66d7aa43dfc917d3159fa75e48e62d322dfada6214" => :sierra
    sha256 "26d58767f5ef9ffd62a45c855e283c22814ca8498ad032bf0e0dcd295bb61166" => :el_capitan
    sha256 "3633758b145f1d4c30136717a2683ed86b9542fd39bf1388f335cf78e22a3b9a" => :yosemite
    sha256 "6cada92988c8402c3b02e1ddc53726fa2b9e2b607851b2365562185a8cb6908e" => :x86_64_linux
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

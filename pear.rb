class Pear < Formula
  desc "Ultrafast, memory-efficient and highly accurate pair-end read merger"
  homepage "http://www.exelixis-lab.org/pear"
  # doi "10.1093/bioinformatics/btt593"
  # tag "bioinformatics"

  url "http://sco.h-its.org/exelixis/web/software/pear/files/pear-0.9.10.tar.gz"
  sha256 "ebb0a1a26300b4d54e6a470b0dd17c364aedcf8d4bfab1106649a2d502a76203"

  # patch needed for Yosemite, should be fixed in version > 0.9.10
  patch :DATA

  bottle do
    cellar :any
    sha256 "a41b6229ea725bf74c1c6cf2383f55d21b91cd98197f441ca9c7ec6f0fa1416f" => :yosemite
    sha256 "d23c4c17880e9eef24ce46c2ab55662e59ec0bf69da43be96fd19158c7001efc" => :mavericks
    sha256 "426c5620df6007bfe8ea65181ebcfecf4b0f63cb657e346296af21a994e88d7e" => :mountain_lion
    sha256 "377d1990fe1f56ad5dcb2ea9c4729d9140fbb18ff46590874b1685ce005a4c62" => :x86_64_linux
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pear --help 2>&1 |grep -q pear"
  end
end

__END__
diff --git a/src/pear-pt.c b/src/pear-pt.c
index 9cd60fa..1a458cd 100644
--- a/src/pear-pt.c
+++ b/src/pear-pt.c
@@ -4,6 +4,7 @@
 #include <math.h>
 #include <pthread.h>
 #include <assert.h>
+#include <stdarg.h>
 #include "args.h"
 #include "emp.h"
 #include "reader.h"

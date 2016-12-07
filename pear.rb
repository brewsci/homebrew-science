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
    cellar :any_skip_relocation
    sha256 "73b55d6cfc3954d6756fe67b20077268e9e973e3f26e9c8ce85fcbe289befe77" => :sierra
    sha256 "1b490a3d62ebd31b2cc826c9e0738a813d4df42232cd2c57ad9c8526222bcc29" => :el_capitan
    sha256 "43ec5d9b42f167c8ca04a9270dcf965fe25cbe0c803978d0581b3ee2ce4c47db" => :yosemite
    sha256 "72f716de66b1fccca92cf9ff14e90c5d70455217491981daae85a9f0fb89fe08" => :x86_64_linux
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

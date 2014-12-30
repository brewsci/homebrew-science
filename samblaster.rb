class Samblaster < Formula
  homepage "https://github.com/GregoryFaust/samblaster"
  #doi "10.1093/bioinformatics/btu314"
  #tag "bioinformatics"

  url "https://github.com/GregoryFaust/samblaster/releases/download/v.0.1.20/samblaster-v.0.1.20.tar.gz"
  sha1 "202eef231c7d4e188a7ec1646702642ecf976037"
  head "https://github.com/GregoryFaust/samblaster"

  # Pull request submitted upstream:
  # https://github.com/GregoryFaust/samblaster/pull/8
  patch :DATA

  def install
    inreplace "samblaster.cpp", "sig_t", "signal_t"
    system "make"
    bin.install "samblaster"
  end

  test do
    system "#{bin}/samblaster", "--version"
  end
end

__END__
diff --git a/samblaster.cpp b/samblaster.cpp
index 14a2a40..1d8f52c 100644
--- a/samblaster.cpp
+++ b/samblaster.cpp
@@ -26,6 +26,13 @@
 #include <map>
 #include "sbhash.h"

+// Define mempcpy for Mac OS
+#ifdef __APPLE__
+void* mempcpy(void* dst, const void* src, size_t len) {
+    return (char*)memcpy(dst, src, len) + len;
+}
+#endif
+
 // Rename common integer types.
 // I like having these shorter name.
 typedef uint64_t UINT64;

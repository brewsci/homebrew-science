require 'formula'

# NCO: Tools for slicing and dicing NetCDF files.

class Nco < Formula
  homepage 'http://nco.sourceforge.net'
  url 'http://nco.sourceforge.net/src/nco_4.1.0.orig.tar.gz'
  sha1 'ae708d5b81fe8296ca47cb2110aef6aec2f65a2b'

  depends_on 'netcdf'
  depends_on 'gsl'
  depends_on 'udunits'

  # NCO requires the C++ interface in Antlr2.
  depends_on 'homebrew/versions/antlr2'

  def patches
    # Fix include statements pointing to `malloc.h`.
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-netcdf4"
    system "make install"
  end
end

__END__
diff --git a/autobld/ltmain.sh b/autobld/ltmain.sh
index b4a3231..b1e5aa0 100644
--- a/autobld/ltmain.sh
+++ b/autobld/ltmain.sh
@@ -4160,7 +4160,7 @@ EOF
 #  include <io.h>
 # endif
 #endif
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <stdarg.h>
 #include <assert.h>
 #include <string.h>
diff --git a/src/nco++/Invoke.cc b/src/nco++/Invoke.cc
index 393e5c3..f3eb439 100644
--- a/src/nco++/Invoke.cc
+++ b/src/nco++/Invoke.cc
@@ -9,7 +9,7 @@
 // this defines an anonymous enum containing parser tokens
 
 #include <stdio.h>
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <fstream>
 #include <sstream>
 #include <antlr/AST.hpp>
diff --git a/src/nco++/NcapVector.hh b/src/nco++/NcapVector.hh
index a8ca59b..80cbd41 100644
--- a/src/nco++/NcapVector.hh
+++ b/src/nco++/NcapVector.hh
@@ -1,7 +1,7 @@
 #ifndef INC_NcapVector_hh_
 #define INC_NcapVector_hh_
 
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <string.h>
 #include <functional>
 #include <string>
diff --git a/src/nco++/ncoLexer.hpp b/src/nco++/ncoLexer.hpp
index 012b5b8..848f41d 100644
--- a/src/nco++/ncoLexer.hpp
+++ b/src/nco++/ncoLexer.hpp
@@ -21,7 +21,7 @@
     // C Standard Headers
     #include <assert.h>
     #include <ctype.h>
-    #include <malloc.h>
+    #include <sys/malloc.h>
     #include <math.h>
     #if !(defined __xlC__) && !(defined SGIMP64) // C++ compilers that do not allow stdint.h
     #include <stdint.h> // Required by g++ for LLONG_MAX, ULLONG_MAX, by icpc for int64_t    
diff --git a/src/nco++/ncoParser.hpp b/src/nco++/ncoParser.hpp
index 870213f..a04ebce 100644
--- a/src/nco++/ncoParser.hpp
+++ b/src/nco++/ncoParser.hpp
@@ -21,7 +21,7 @@
     // C Standard Headers
     #include <assert.h>
     #include <ctype.h>
-    #include <malloc.h>
+    #include <sys/malloc.h>
     #include <math.h>
     #if !(defined __xlC__) && !(defined SGIMP64) // C++ compilers that do not allow stdint.h
     #include <stdint.h> // Required by g++ for LLONG_MAX, ULLONG_MAX, by icpc for int64_t    
diff --git a/src/nco++/ncoTree.hpp b/src/nco++/ncoTree.hpp
index ccf4bd3..416b65e 100644
--- a/src/nco++/ncoTree.hpp
+++ b/src/nco++/ncoTree.hpp
@@ -19,7 +19,7 @@
     // C Standard Headers
     #include <assert.h>
     #include <ctype.h>
-    #include <malloc.h>
+    #include <sys/malloc.h>
     #include <math.h>
     #if !(defined __xlC__) && !(defined SGIMP64) // C++ compilers that do not allow stdint.h
     #include <stdint.h> // Required by g++ for LLONG_MAX, ULLONG_MAX, by icpc for int64_t    

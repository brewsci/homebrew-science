require 'formula'

class SpatialiteGis < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite_gis/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite_gis-1.0.0c.tar.gz'
  sha1 '45508b27fbdc7166ef874ce3f79216d6c01f3c4f'

  depends_on 'libspatialite'
  depends_on 'librasterlite'

  depends_on 'wxmac'

  def patches
    {
      # Upstream fix for bad test of string equality. Remove on next release.
      :p0 => 'https://www.gaia-gis.it/fossil/spatialite_gis/vpatch?from=0506d89e65c692d7&to=0783daf1178ee1dc',
      # Allow `spatialite_gis` to run without being packaged as an .app bundle.
      :p1 => DATA
    }
  end

  def install
    # These libs don't get picked up by configure.
    ENV.append 'LDFLAGS', '-lwx_osx_cocoau_aui-2.9 -liconv'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
Fix GUI so it can run without needing to construct an app bundle.

diff --git a/Main.cpp b/Main.cpp
index f90575e..2c6f7a3 100644
--- a/Main.cpp
+++ b/Main.cpp
@@ -39,6 +39,12 @@
 #include <proj_api.h>
 #include <geos_c.h>
 
+#ifdef __WXMAC__
+// Allow the program to run and recieve focus without creating an app bundle.
+#include <Carbon/Carbon.h>
+extern "C" { void CPSEnableForegroundOperation(ProcessSerialNumber* psn); }
+#endif
+
 //
 // ICONs in XPM format [universally portable]
 //
@@ -87,6 +93,21 @@ IMPLEMENT_APP(MyApp)
   frame->Show(true);
   SetTopWindow(frame);
   frame->LoadConfig(path);
+
+#ifdef __WXMAC__
+  // Acquire the necessary resources to run as a GUI app without being inside
+  // an app bundle.
+  //
+  // Credit for this hack goes to:
+  //
+  //   http://www.miscdebris.net/blog/2010/03/30/solution-for-my-mac-os-x-gui-program-doesnt-get-focus-if-its-outside-an-application-bundle
+  ProcessSerialNumber psn;
+
+  GetCurrentProcess( &psn );
+  CPSEnableForegroundOperation( &psn );
+  SetFrontProcess( &psn );
+#endif
+
   return true;
 }
 

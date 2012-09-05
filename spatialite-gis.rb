require 'formula'

class SpatialiteGis < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite_gis/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite_gis-1.0.0c.tar.gz'
  sha1 '45508b27fbdc7166ef874ce3f79216d6c01f3c4f'

  depends_on 'libspatialite'
  depends_on 'librasterlite'

  depends_on 'wxmac'

  def patches
    DATA
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
Fix bad tests for string equality?


diff --git a/MapView.cpp b/MapView.cpp
index 11cd5df..9ab5689 100644
--- a/MapView.cpp
+++ b/MapView.cpp
@@ -1160,7 +1160,7 @@ void MyMapView::OnTimerIdentify(wxTimerEvent & WXUNUSED(event))
       if (layer->GetType() == VECTOR_LAYER)
         {
           if (layer->GetTableName() == active->GetTableName() &&
-              layer->GetGeometryColumn() && active->GetGeometryColumn())
+              layer->GetGeometryColumn() == active->GetGeometryColumn())
             {
               // OK: performing Identify
               Identify(layer, IdentifyMouseX, IdentifyMouseY);
@@ -1789,7 +1789,7 @@ void MyMapView::OnCmdIdentify(wxCommandEvent & WXUNUSED(event))
           if (layer->GetType() == VECTOR_LAYER)
             {
               if (layer->GetTableName() == active->GetTableName() &&
-                  layer->GetGeometryColumn() && active->GetGeometryColumn())
+                  layer->GetGeometryColumn() == active->GetGeometryColumn())
                 {
                   // OK: performing Identify
                   Identify(layer, MouseIdentifyX, MouseIdentifyY);


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
 

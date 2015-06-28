class Qhull < Formula
  desc "Qhull is a code for computing convex hulls in n dimensions."
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2012.1-src.tgz"
  mirror "http://lil.fr.distfiles.macports.org/qhull/qhull-2012.1-src.tgz"
  sha256 "a35ecaa610550b7f05c3ce373d89c30cf74b059a69880f03080c556daebcff88"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "67b8992742d9c2bd0a07d731aa6ed7a55ac361f9" => :yosemite
    sha1 "9ea434329af6194b30a0fee4cf2833fdb208929a" => :mavericks
    sha1 "ff1e819f3427676f55b21a9da9e3378229b72a62" => :mountain_lion
  end

  depends_on "cmake" => :build

  # Patch originally from MacPorts - cosmetic edits to CMakeLists.txt:
  #
  #  * The VERSION property is no longer set on the command line tools.
  #    Setting this property causes CMake to install `binname-version` along
  #    with a symlink `binname` that points to `binname-version`. This is
  #    pointless for something that is managed by a package manager.
  # https://trac.macports.org/export/83287/trunk/dports/math/qhull/files/patch-CMakeLists.txt.diff'}
  #
  # Patch originally from MacPorts - qhull does not compile with clang 3.5.0:
  #
  #  * Avoid dependence on <iterator>
  # http://lists.freebsd.org/pipermail/freebsd-ports-bugs/2014-December/298242.html
  # https://trac.macports.org/export/136618/trunk/dports/math/qhull/files/patch-use-stl-iterator.diff
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/rbox c D2 | #{bin}/qconvex s n"
  end
end

__END__
--- a/CMakeLists.txt	2012-02-21 19:38:47.000000000 -0800
+++ b/CMakeLists.txt	2012-06-18 09:33:28.000000000 -0700
@@ -312,13 +312,10 @@
 # ---------------------------------------
 
 add_library(${qhull_STATIC} STATIC ${libqhull_SOURCES})
-set_target_properties(${qhull_STATIC} PROPERTIES
-    VERSION ${qhull_VERSION})
 
 add_library(${qhull_STATICP} STATIC ${libqhull_SOURCES})
 set_target_properties(${qhull_STATICP} PROPERTIES
-    COMPILE_DEFINITIONS "qh_QHpointer"
-    VERSION ${qhull_VERSION})
+    COMPILE_DEFINITIONS "qh_QHpointer")
 
 if(UNIX)
     target_link_libraries(${qhull_STATIC} m)
@@ -331,8 +328,7 @@
 
 add_library(${qhull_CPP} STATIC ${libqhullcpp_SOURCES})
 set_target_properties(${qhull_CPP} PROPERTIES
-    COMPILE_DEFINITIONS "qh_QHpointer"
-    VERSION ${qhull_VERSION})
+    COMPILE_DEFINITIONS "qh_QHpointer")
 
 # ---------------------------------------
 # Define qhull executables linked to qhullstatic library
--- a/src/libqhullcpp/QhullIterator.h	2012-01-26 04:32:05.000000000 +0100
+++ b/src/libqhullcpp/QhullIterator.h	2014-12-19 15:19:26.000000000 +0100
@@ -16,8 +16,7 @@
 #include <assert.h>
 #include <string>
 #include <vector>
-//! Avoid dependence on <iterator>
-namespace std { struct bidirectional_iterator_tag; struct random_access_iterator_tag; }
+#include <iterator>

 namespace orgQhull {

--- a/src/libqhullcpp/QhullLinkedList.h	2012-01-26 04:32:05.000000000 +0100
+++ b/src/libqhullcpp/QhullLinkedList.h	2014-12-19 15:19:26.000000000 +0100
@@ -9,7 +9,7 @@
 #ifndef QHULLLINKEDLIST_H
 #define QHULLLINKEDLIST_H

-namespace std { struct bidirectional_iterator_tag; struct random_access_iterator_tag; }
+#include <iterator>

 #include "QhullError.h"

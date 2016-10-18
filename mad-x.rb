class MadX < Formula
  desc "Methodical Accelerator Design"
  homepage "https://cern.ch/mad"

  url "http://svn.cern.ch/guest/madx/tags/5.02.12/madX/"
  head "http://svn.cern.ch/guest/madx/trunk/madX/"

  bottle do
    cellar :any
    sha256 "47118481abb0e82d5c1a5daf6634ff3627147536877e77c7cd0d4bfc36649fd4" => :sierra
    sha256 "211f4542a5fd90eda1cb39d2834b8ff21384953a7bdf898f96bd8bf142759952" => :el_capitan
    sha256 "277924e195dc4656a7735d7451145010708549f3a02f4ed14092968906d56864" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :x11

  patch :DATA

  def install
    system "cmake", "-DBUILD_SHARED_LIBS=ON", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.txt").write("option,-echo;print,text='Hello,Mad-X';stop;")
    assert_match "Hello,Mad-X", shell_output("madx_dev < hello.txt")
  end
end

__END__
diff --git a/syntax/CMakeLists.txt b/syntax/CMakeLists.txt
--- a/syntax/CMakeLists.txt
+++ b/syntax/CMakeLists.txt
@@ -7,7 +7,7 @@
       OPTIONAL)
   endif()
   install(FILES emacs/madx.el
-    DESTINATION "share/emacs/site-lisp/"
+    DESTINATION "share/emacs/site-lisp/mad-x/"
     OPTIONAL)
   install(FILES vim/madx.vim
     DESTINATION "share/vim/vimfiles/syntax/"
diff --git a/CMakeLists.txt b/CMakeLists.txt
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -59,7 +59,6 @@
 # Add sources subdirectory:
 add_subdirectory(libs/ptc)
 add_subdirectory(src)
-add_subdirectory(tools)
 add_subdirectory(syntax)

 # Install documentation as well:
@@ -71,4 +70,3 @@
 # Setting up testing:
 include(setupTesting)
 # Add test folders:
-include(ndifftests)

class Jsbsim < Formula
  desc "Open source flight dynamics model"
  homepage "http://jsbsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/jsbsim/JSBSim_Source/JSBSim%20v1.0%20Release%20Candidate%202/JSBSim-1.0.rc2.tar.gz"
  version "1.0.rc2"
  sha256 "04accd4efc75867edfa6eeb814ceefebf519b2e8d750518b1de0a6aafa9442e1"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a88430d291a5ffb8cff4dd62c122acc976cf10e0a7a362e06b1713447ecb742a" => :el_capitan
    sha256 "a98477ca4a33b32e4bcabce5a0c8a941992afbde2c5056a7a15fc385fdf811a9" => :yosemite
    sha256 "992d34b5e4c61efdaeda03c3a493db32094e63c38909fb4cdf082fdcd0dfc8c0" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/jsbsim/code"

    # Note: we are removing the compilation of Aeromatic, a web-based
    # configuration file generator for JSBSim. Additionally, we are removing
    # a call to "feenableexcept" which is not available in Clang. We also
    # remove tests since there's a test that also relies on "feenableexcept".
    patch :DATA
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}",
                           "--enable-libraries"

    system "make", "install"

    bin.install "src/JSBSim"
  end

  test do
    system "#{bin}/JSBSim"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2f967c8..468bd34 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -37,8 +37,6 @@ if (CYTHON_FOUND)
   find_package(PythonLibs)
   if (PYTHONLIBS_FOUND)
     include_directories(${CMAKE_CURRENT_LIST_DIR}/src)
-    enable_testing()
-    add_subdirectory(tests)
   endif(PYTHONLIBS_FOUND)
 endif(CYTHON_FOUND)

diff --git a/src/JSBSim.cpp b/src/JSBSim.cpp
index 65cd3ed..fab3310 100644
--- a/src/JSBSim.cpp
+++ b/src/JSBSim.cpp
@@ -288,7 +288,6 @@ int main(int argc, char* argv[])
   _controlfp(_controlfp(0, 0) & ~(_EM_INVALID | _EM_ZERODIVIDE | _EM_OVERFLOW),
            _MCW_EM);
 #elif defined(__GNUC__) && !defined(sgi)
-  feenableexcept(FE_DIVBYZERO | FE_INVALID);
 #endif

   try {
diff --git a/utils/CMakeLists.txt b/utils/CMakeLists.txt
index bd08efb..8b13789 100644
--- a/utils/CMakeLists.txt
+++ b/utils/CMakeLists.txt
@@ -1,2 +1 @@

-add_subdirectory(aeromatic++)

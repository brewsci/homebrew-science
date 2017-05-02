class MadX < Formula
  desc "Methodical Accelerator Design"
  homepage "https://cern.ch/mad"

  url "http://svn.cern.ch/guest/madx/tags/5.02.13/madX/"
  revision 1
  head "http://svn.cern.ch/guest/madx/trunk/madX/"

  bottle do
    cellar :any
    sha256 "5535734990b7d439653f2115861fa18bc8591859bf154ac8462b34855002a357" => :sierra
    sha256 "68a7bfa5609fdfeafa3dfe6987babf759dea7ce1e5bb0df7494b246d485d5948" => :el_capitan
    sha256 "96f07958d0a64203f6328ffd857ad3ae68bb1a8baee8bc4410c35abb0e4961b2" => :yosemite
    sha256 "931eb6e5349ec2a16748e9ec812b5ede7462f5d82bc31fdb15550e88db18ddaf" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :x11
  depends_on "openblas" unless OS.mac?

  patch :DATA

  def install
    system "cmake", "-DBUILD_SHARED_LIBS=ON", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.txt").write("option,-echo;print,text='Hello,Mad-X';stop;")
    assert_match "Hello,Mad-X", shell_output("#{bin}/madx_dev < hello.txt")
  end
end

__END__
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

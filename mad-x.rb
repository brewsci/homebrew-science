class MadX < Formula
  desc "Methodical Accelerator Design"
  homepage "https://cern.ch/mad"

  url "http://svn.cern.ch/guest/madx/tags/5.03.06/madX/"
  head "http://svn.cern.ch/guest/madx/trunk/madX/"

  bottle do
    cellar :any
    sha256 "40ccbc6290f8760a7c30abfea2a5de8abbd56b337d4854dfac599b7f4930d82a" => :sierra
    sha256 "13800e6b51ee23d53d08c43cda553744fb0472ab93a42fa1367956658592bec9" => :el_capitan
    sha256 "b15aae28e6069fa7694bdb4f4bed3832c5c5fc51a07304d650d3fdcdfd941e74" => :yosemite
    sha256 "77844850e32a6d1b720fbe611d0f158257036156f4419f07374c4e8d2a4b436c" => :x86_64_linux
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

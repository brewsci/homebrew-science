class MadX < Formula
  desc "Methodical Accelerator Design"
  homepage "https://cern.ch/mad"

  url "http://svn.cern.ch/guest/madx/tags/5.03.06/madX/"
  head "http://svn.cern.ch/guest/madx/trunk/madX/"

  bottle do
    cellar :any
    sha256 "54d31a73ae0744b8093fff79a26bf797012086f00fcf65fdc9dae7251136c991" => :sierra
    sha256 "3104a72c54c91f2899641da479137bfe837d4e3970922a9791e19ea6b8c0f5a6" => :el_capitan
    sha256 "1afe12d2cc762817778b54e944b7f40a917d6b605e8ad44bf041bf37a7991c2e" => :yosemite
    sha256 "4aa0d38e225db847c52021e02fab17729dc079e721af1aba7770d53e6a2062a0" => :x86_64_linux
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

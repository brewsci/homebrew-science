class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.8.tar.gz"
  sha256 "9964b537f0af121560e64cb5a2513b153511ca85e011f23a332c45cc66f3d60a"

  bottle do
    cellar :any
    sha256 "615b58ba255381b82f90d63866ba6c6431a45c7af6226569c25176c835e688b6" => :el_capitan
    sha256 "0b6ca452b5ea924d320c5e9971b593d80ecb360656021effb38ad0237c358b29" => :yosemite
    sha256 "f5c2aa97b3cf6add9d2c528d84c4744ff970b65e23aa63586a3c4c10d3bcaa4f" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build

  # https://github.com/clMathLibraries/clFFT/pull/127
  patch :DATA

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "../src", "-DBUILD_EXAMPLES:BOOL=OFF", "-DBUILD_TEST:BOOL=OFF", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "src/examples"
  end

  test do
    system ENV.cxx, "#{pkgshare}/examples/fft1d.c", "-I#{opt_include}", "-L#{opt_lib}", "-lclFFT", "-framework", "OpenCL", "-o", "fft1d"
    assert_match "(120.000000, 360.000000)", `./fft1d`
  end
end

__END__
diff --git a/src/callback-client/client.h b/src/callback-client/client.h
index 1b75e29..31c0264 100644
--- a/src/callback-client/client.h
+++ b/src/callback-client/client.h
@@ -93,6 +93,29 @@ public:
     }
 };

+#elif defined(__APPLE__) || defined(__MACOSX)
+
+#include <mach/clock.h>
+#include <mach/mach.h>
+
+struct Timer
+{
+    clock_serv_t clock;
+    mach_timespec_t start, end;
+
+public:
+    Timer() { host_get_clock_service(mach_host_self(), SYSTEM_CLOCK, &clock); }
+    ~Timer() { mach_port_deallocate(mach_task_self(), clock); }
+
+    void Start() { clock_get_time(clock, &start); }
+    double Sample()
+    {
+        clock_get_time(clock, &end);
+        double time = 1000000000L * (end.tv_sec - start.tv_sec) + end.tv_nsec - start.tv_nsec;
+        return time * 1E-9;
+    }
+};
+
 #else

 #include <time.h>

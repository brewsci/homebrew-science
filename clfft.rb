class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.8.tar.gz"
  sha256 "9964b537f0af121560e64cb5a2513b153511ca85e011f23a332c45cc66f3d60a"

  bottle do
    cellar :any
    sha256 "fd803537e3af8d9189852ac87001d6be4562f5a20a9d8cb11d799548dbc71bb5" => :yosemite
    sha256 "8265a5b1a675ad57825240e75cc58bf3a83996808019f6fc43cc7c55c78fc8c8" => :mavericks
    sha256 "135f7e329b29dbadf53bfa4c6b8110800fefc013edbf88c5263b8618ff3008e9" => :mountain_lion
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

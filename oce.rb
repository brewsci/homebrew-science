class Oce < Formula
  desc "Open CASCADE Community Edition"
  homepage "https://github.com/tpaviot/oce"
  url "https://github.com/tpaviot/oce/archive/OCE-0.18.tar.gz"
  sha256 "226e45e77c16a4a6e127c71fefcd171410703960ae75c7ecc7eb68895446a993"
  revision 2

  bottle do
    sha256 "95b2fe2ee8e109a3a367d6c385a05b2fd1ab9cf6375a2f446427adc4588280d6" => :sierra
    sha256 "371b8ce925904138c013dd6fbf9b750e290dee7968a1424908387a85df7022b8" => :el_capitan
    sha256 "18a247ef0da6668452a160548db5aea464c4f147ae52b00000b496336490351e" => :yosemite
    sha256 "80881db2fb51be4b5fba7387b497fc84888a8d8e76913a99a1a14109d06a4804" => :x86_64_linux
  end

  option "without-opencl", "Build without OpenCL support"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "freeimage" => :recommended
  depends_on "gl2ps" => :recommended
  depends_on "tbb" => :recommended
  depends_on :macos => :snow_leopard

  unless OS.mac?
    depends_on "tcl-tk"
  end

  conflicts_with "opencascade", :because => "OCE is a fork for patches/improvements/experiments over OpenCascade"

  # fix build with Xcode 8 "previous definition of CLOCK_REALTIME"
  # reported 27 Sep 2016 https://github.com/tpaviot/oce/issues/643
  patch :DATA if !DevelopmentTools.clang_version.nil? && DevelopmentTools.clang_version >= "8.0"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DOCE_INSTALL_PREFIX:STRING=#{prefix}"
    cmake_args << "-DOCE_COPY_HEADERS_BUILD:BOOL=ON"
    cmake_args << "-DOCE_DRAW:BOOL=ON"
    cmake_args << "-DOCE_MULTITHREAD_LIBRARY:STRING=TBB" if build.with? "tbb"
    cmake_args << "-DFREETYPE_INCLUDE_DIRS=#{Formula["freetype"].opt_include}/freetype2"

    %w[freeimage gl2ps].each do |feature|
      cmake_args << "-DOCE_WITH_#{feature.upcase}:BOOL=ON" if build.with? feature
    end

    opencl_path = Pathname.new "/System/Library/Frameworks/OpenCL.framework"
    if build.with?("opencl") && opencl_path.exist?
      cmake_args << "-DOCE_WITH_OPENCL:BOOL=ON"
      cmake_args << "-DOPENCL_LIBRARIES:PATH=#{opencl_path}"
      cmake_args << "-D_OPENCL_CPP_INCLUDE_DIRS:PATH=#{opencl_path}/Headers"
    end

    system "cmake", ".", *cmake_args
    system "make", "install/strip"
  end

  def caveats; <<-EOF.undent
    Some apps will require this enviroment variable:
      CASROOT=#{opt_share}/oce-#{version.to_s.split(".")[0..1].join(".")}
    EOF
  end

  test do
    vers = version.to_s.split(".")[0..1].join(".")
    cmd = "CASROOT=#{share}/oce-#{vers} #{bin}/DRAWEXE -v -c \"pload ALL\""
    assert_equal "1", shell_output(cmd).chomp
  end
end

__END__
diff --git a/src/OSD/OSD_Chronometer.cxx b/src/OSD/OSD_Chronometer.cxx
index f7374fb..63ac140 100644
--- a/src/OSD/OSD_Chronometer.cxx
+++ b/src/OSD/OSD_Chronometer.cxx
@@ -51,7 +51,7 @@
   #include <mach/mach.h>
 #endif

-#if defined(__APPLE__) && defined(__MACH__)
+#if defined(__APPLE__) && !defined(__MAC_10_12)
 #include "gettime_osx.h"
 #endif

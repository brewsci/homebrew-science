class CudaRequirement < Requirement
  build true
  fatal true

  satisfy { which "nvcc" }

  env do
    # Nvidia CUDA installs (externally) into this dir (hard-coded):
    ENV.append "CFLAGS", "-F/Library/Frameworks"
    # # because nvcc has to be used
    ENV.append "PATH", which("nvcc").dirname, ":"
  end

  def message
    <<-EOS.undent
      To use this formula with NVIDIA graphics cards you will need to
      download and install the CUDA drivers and tools from nvidia.com.

          https://developer.nvidia.com/cuda-downloads

      Select "Mac OS" as the Operating System and then select the
      'Developer Drivers for MacOS' package.
      You will also need to download and install the 'CUDA Toolkit' package.

      The `nvcc` has to be in your PATH then (which is normally the case).

    EOS
  end
end

class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz"
  sha256 "479f84f2c658a6319b78271111251b4c2d6cf07643421b66bbc351d9bed0ae93"

  stable do
    patch do
      url "https://gist.githubusercontent.com/fran6co/a6e1e44b1b43b2d150cd/raw/0c4aeb301ed523c81cd57c63b0a9804d49af9848/boost.patch"
      sha1 "af223b0d312a0404d5c9281de62f0cedd9e3651a"
    end
    # Fixes PCL for VTK 6.2.0
    patch do
      url "https://patch-diff.githubusercontent.com/raw/PointCloudLibrary/pcl/pull/1205.patch"
      sha1 "27770e8945cc53bac0bb0a1215d658cdb62120d3"
    end
  end

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "25768ba908632c255f145863c059f4d1f19b0afbbc61be02b111a245d87123af" => :yosemite
    sha256 "16c17967a634d7dd333260831e17f27b789ad9974386e5fe24afa84c4660c2a4" => :mavericks
    sha256 "af68e8660c7ea62b076aa2b2d4797d250b2d6aae67d16d0b2b4fc5b07488b2d4" => :mountain_lion
  end

  head do
    url "https://github.com/PointCloudLibrary/pcl.git"

    depends_on "glew"
    depends_on CudaRequirement => :optional

    # CUDA 6.5 works with libc++
    patch :DATA
  end

  option "with-examples", "Build pcl examples."
  option "without-tools", "Build without tools."
  option "without-apps", "Build without apps."

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "cminpack"

  depends_on "qhull"
  depends_on "libusb"
  depends_on "qt" => :recommended
  if build.with? "qt"
    depends_on "sip" # Fix for building system
    depends_on "pyqt" # Fix for building system
    depends_on "vtk" => [:recommended, "with-qt"]
  else
    depends_on "vtk" => :recommended
  end
  depends_on "openni" => :optional
  depends_on "openni2" => :optional

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_simulation:BOOL=AUTO_OFF
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=AUTO_OFF
      -DBUILD_global_tests:BOOL=OFF
      -DWITH_TUTORIALS:BOOL=OFF
      -DWITH_DOCS:BOOL=OFF
    ]

    if build.head? && (build.with? "cuda")
      args << "-DWITH_CUDA:BOOL=AUTO_OFF"
    else
      args << "-DWITH_CUDA:BOOL=OFF"
    end

    if build.with? "openni2"
      ENV.append "OPENNI2_INCLUDE", "#{Formula["openni2"].opt_include}/ni2"
      ENV.append "OPENNI2_LIB", "#{Formula["openni2"].opt_lib}/ni2"
      args << "-DBUILD_OPENNI2:BOOL=ON"
    end

    if build.with? "apps"
      args += %W[
        -DBUILD_apps=AUTO_OFF
        -DBUILD_apps_3d_rec_framework=AUTO_OFF
        -DBUILD_apps_cloud_composer=AUTO_OFF
        -DBUILD_apps_in_hand_scanner=AUTO_OFF
        -DBUILD_apps_modeler=AUTO_OFF
        -DBUILD_apps_optronic_viewer=AUTO_OFF
        -DBUILD_apps_point_cloud_editor=AUTO_OFF
      ]
    else
      args << "-DBUILD_apps:BOOL=OFF"
    end

    args << "-DBUILD_tools:BOOL=OFF" if build.without? "tools"

    if build.with? "examples"
      args << "-DBUILD_examples:BOOL=ON"
    else
      args << "-DBUILD_examples:BOOL=OFF"
    end

    if build.with? "openni"
      args << "-DOPENNI_INCLUDE_DIR=#{Formula["openni"].opt_include}/ni"
    else
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_OpenNI:BOOL=TRUE"
    end

    args << "-DWITH_QT:BOOL=FALSE" if build.without? "qt"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK:BOOL=TRUE" if build.without? "vtk"

    args << ".."
    mkdir "macbuild" do
      system "cmake", *args
      system "make"
      system "make", "install"

      prefix.install Dir["#{bin}/*.app"]
    end
  end
end
__END__
diff --git a/cmake/pcl_find_cuda.cmake b/cmake/pcl_find_cuda.cmake
index 2f0425e..0675a55 100644
--- a/cmake/pcl_find_cuda.cmake
+++ b/cmake/pcl_find_cuda.cmake
@@ -1,16 +1,6 @@
 # Find CUDA
 
 
-# Recent versions of cmake set CUDA_HOST_COMPILER to CMAKE_C_COMPILER which
-# on OSX defaults to clang (/usr/bin/cc), but this is not a supported cuda
-# compiler.  So, here we will preemptively set CUDA_HOST_COMPILER to gcc if
-# that compiler exists in /usr/bin.  This will not override an existing cache
-# value if the user has passed CUDA_HOST_COMPILER on the command line.
-if (NOT DEFINED CUDA_HOST_COMPILER AND CMAKE_C_COMPILER_ID STREQUAL "Clang" AND EXISTS /usr/bin/gcc)
-  set(CUDA_HOST_COMPILER /usr/bin/gcc CACHE FILEPATH "Host side compiler used by NVCC")
-  message(STATUS "Setting CMAKE_HOST_COMPILER to /usr/bin/gcc instead of ${CMAKE_C_COMPILER}.  See http://dev.pointclouds.org/issues/979")
-endif()
-
 if(MSVC11)
 	# Setting this to true brakes Visual Studio builds.
 	set(CUDA_ATTACH_VS_BUILD_RULE_TO_CUDA_FILE OFF CACHE BOOL "CUDA_ATTACH_VS_BUILD_RULE_TO_CUDA_FILE")
@@ -47,10 +37,5 @@ if(CUDA_FOUND)
 	include(${PCL_SOURCE_DIR}/cmake/CudaComputeTargetFlags.cmake)
 	APPEND_TARGET_ARCH_FLAGS()
     
-  # Send a warning if CUDA_HOST_COMPILER is set to a compiler that is known
-  # to be unsupported.
-  if (CUDA_HOST_COMPILER STREQUAL CMAKE_C_COMPILER AND CMAKE_C_COMPILER_ID STREQUAL "Clang")
-    message(WARNING "CUDA_HOST_COMPILER is set to an unsupported compiler: ${CMAKE_C_COMPILER}.  See http://dev.pointclouds.org/issues/979")
-  endif()
 
 endif()

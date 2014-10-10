require "formula"

class CudaRequirement < Requirement
  build true
  fatal true

  satisfy { which 'nvcc' }

  env do
    # Nvidia CUDA installs (externally) into this dir (hard-coded):
    ENV.append 'CFLAGS', "-F/Library/Frameworks"
    # # because nvcc has to be used
    ENV.append 'PATH', which('nvcc').dirname, ':'
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
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz"
  sha1 "7a59e9348a81f42725db1f8b1194c9c3313372ae"
  head "https://github.com/PointCloudLibrary/pcl.git"

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
    depends_on "vtk" => [:recommended,"with-qt"]
  else
    depends_on "vtk" => :recommended
  end
  depends_on "openni" => :optional
  depends_on "openni2" => :optional

  head do
    depends_on "glew"
    depends_on CudaRequirement => :optional

    # CUDA 6.5 works with libc++
    patch :DATA
  end

  stable do
    patch do
      url "https://gist.githubusercontent.com/fran6co/a6e1e44b1b43b2d150cd/raw/e7953b409a6c4a21d8a9ea0b380b440e95a1254b/boost.patch"
      sha1 "6fbce5d408df3883b5f532a1bff4d20a6e78d41a"
    end
  end


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

    if build.head? and build.with? "cuda"
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
      args = args + %W[
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
      system "make install"

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

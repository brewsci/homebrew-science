require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Opencv < Formula
  desc "Open source computer vision library"
  homepage "http://opencv.org/"
  head "https://github.com/opencv/opencv.git", :branch => "2.4"

  stable do
    url "https://github.com/opencv/opencv/archive/2.4.13.1.tar.gz"
    sha256 "0d5ce5e0973e3a745f927d1ee097aaf909aae59f787be6d27a03d639e2d96bd7"

    # patch to fix building stable on macOS Sierra and/or with Xcode 8
    # adds support for AVFoundation and fixes dependencies on removed headers
    # https://github.com/opencv/opencv/issues/6913 (applies to 2.4 branch as well)
    # can be removed with next release
    if !DevelopmentTools.clang_build_version.nil? && DevelopmentTools.clang_build_version >= 800
      patch do
        url "https://github.com/opencv/opencv/commit/9ff63a46fcfe784e6465320af80624a53a98ccaa.diff"
        sha256 "33dd03572c40d2c0ce41910be6318fab1350f72d958f850941aad019dfb67de5"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "82d779bcfb222508f4aa798510acdfcb8224fe77596f7214defd3caa1e5f60ca" => :sierra
    sha256 "5acd7b906e5ba9ff3d10dd201f20293c86d59ee3611834bec927f2c03fa00d71" => :el_capitan
    sha256 "7c5a86df6e270135297dd74f4218ca899a80666ed613300916011ac5a7971f7e" => :yosemite
  end

  option "32-bit"
  option "with-java", "Build with Java support"
  option "with-tbb", "Enable parallel code in OpenCV using Intel TBB"
  option "without-test", "Build without accuracy & performance tests"
  option "without-opencl", "Disable GPU code in OpenCV using OpenCL"
  option "with-opengl", "Build with OpenGL support"
  option "with-ximea", "Build with XIMEA support"
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-python", "Build without Python support"

  if DevelopmentTools.clang_build_version.nil? || DevelopmentTools.clang_build_version < 800
    option "with-quicktime", "Use QuickTime for Video I/O"
  end

  deprecated_option "without-brewed-numpy" => "without-numpy"
  deprecated_option "without-tests" => "without-test"

  option :cxx11
  option :universal

  depends_on :ant if build.with? "java"
  depends_on "cmake"      => :build
  depends_on CudaRequirement => :optional
  depends_on "eigen"      => :recommended
  depends_on "gstreamer"  => :optional
  depends_on "gst-plugins-good" if build.with? "gstreamer"
  depends_on "jasper"     => :optional
  depends_on :java        => :optional
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libdc1394"  => :optional
  depends_on "openexr"    => :recommended
  depends_on "openni"     => :optional
  depends_on "pkg-config" => :build
  depends_on "tbb"        => :optional
  depends_on "vtk"        => :optional

  depends_on :python => :recommended unless OS.mac? && MacOS.version > :snow_leopard
  depends_on "homebrew/python/numpy" => :recommended if build.with? "python"

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway. Will depend on openexr if it's installed.
  depends_on "ffmpeg" => :optional

  def arg_switch(opt)
    (build.with? opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?
    jpeg = Formula["jpeg"]
    dylib = OS.mac? ? "dylib" : "so"

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_ZLIB=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_PNG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DJPEG_INCLUDE_DIR=#{jpeg.opt_include}
      -DJPEG_LIBRARY=#{jpeg.opt_lib}/libjpeg.#{dylib}
    ]
    args << "-DBUILD_TESTS=OFF" << "-DBUILD_PERF_TESTS=OFF" if build.without? "test"
    args << "-DBUILD_opencv_python=" + arg_switch("python")
    args << "-DBUILD_opencv_java=" + arg_switch("java")
    args << "-DWITH_OPENEXR="   + arg_switch("openexr")
    args << "-DWITH_EIGEN="     + arg_switch("eigen")
    args << "-DWITH_TBB="       + arg_switch("tbb")
    args << "-DWITH_FFMPEG="    + arg_switch("ffmpeg")
    args << "-DWITH_QUICKTIME=" + arg_switch("quicktime")
    args << "-DWITH_1394="      + arg_switch("libdc1394")
    args << "-DWITH_OPENGL="    + arg_switch("opengl")
    args << "-DWITH_JASPER="    + arg_switch("jasper")
    args << "-DWITH_GSTREAMER=" + arg_switch("gstreamer")
    args << "-DWITH_XIMEA="     + arg_switch("ximea")
    args << "-DWITH_VTK="       + arg_switch("vtk")

    if build.with? "python"
      py_prefix = `python-config --prefix`.chomp
      py_lib = OS.linux? ? `python-config --configdir`.chomp : "#{py_prefix}/lib"
      args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.#{dylib}"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"
      # Make sure find_program locates system Python
      # https://github.com/Homebrew/homebrew-science/issues/2302
      args << "-DCMAKE_PREFIX_PATH=#{py_prefix}" if OS.mac?
    end

    if build.with? "cuda"
      ENV["CUDA_NVCC_FLAGS"] = "-Xcompiler -stdlib=libc++; -Xlinker -stdlib=libc++"
      args << "-DWITH_CUDA=ON"
      args << "-DCMAKE_CXX_FLAGS=-stdlib=libc++"
      args << "-DCUDA_GENERATION=Kepler"
    else
      args << "-DWITH_CUDA=OFF"
    end

    # OpenCL 1.1 is required, but Snow Leopard and older come with 1.0
    args << "-DWITH_OPENCL=OFF" if build.without?("opencl") || MacOS.version < :lion

    if build.with? "openni"
      args << "-DWITH_OPENNI=ON"
      # Set proper path for Homebrew's openni
      inreplace "cmake/OpenCVFindOpenNI.cmake" do |s|
        s.gsub! "/usr/include/ni", Formula["openni"].opt_include/"ni"
        s.gsub! "/usr/lib", Formula["openni"].opt_lib
      end
    end

    if build.include? "32-bit"
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
      args << "-DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'"
      args << "-DOPENCV_EXTRA_CXX_FLAGS='-arch i386 -m32'"
    end

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    if ENV.compiler == :clang && !build.bottle?
      args << "-DENABLE_SSSE3=ON" if Hardware::CPU.ssse3?
      args << "-DENABLE_SSE41=ON" if Hardware::CPU.sse4?
      args << "-DENABLE_SSE42=ON" if Hardware::CPU.sse4_2?
      args << "-DENABLE_AVX=ON" if Hardware::CPU.avx?
    end

    mkdir "macbuild" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <opencv/cv.h>
      #include <iostream>
      int main()
      {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s

    assert_match version.to_s, shell_output("python -c 'import cv2; print(cv2.__version__)'")
  end
end

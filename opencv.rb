class Opencv < Formula
  homepage "http://opencv.org/"
  head "https://github.com/Itseez/opencv.git"

  stable do
    url "https://github.com/Itseez/opencv/archive/2.4.10.1.tar.gz"
    sha256 "1be191790a0e279c085ddce62f44b63197f2801e3eb66b5dcb5e19c52a8c7639"
    # do not blacklist GStreamer
    # https://github.com/Itseez/opencv/pull/3639
    patch :DATA
  end

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "ccc506ef6cf339048d21c4ef3d8995c76706c9d9" => :yosemite
    sha1 "fc69f870b36504f271dfe42deb5cb27c49bf21cd" => :mavericks
    sha1 "1726a921ced13ebe7f2df0f18f64997091070f71" => :mountain_lion
  end

  devel do
    url "https://github.com/Itseez/opencv/archive/3.0.0-beta.tar.gz"
    sha1 "560895197d1a61ed88fab9ec791328c4c57c0179"
    version "3.0.0-beta"
  end

  option "32-bit"
  option "with-java", "Build with Java support"
  option "with-qt", "Build the Qt4 backend to HighGUI"
  option "with-tbb", "Enable parallel code in OpenCV using Intel TBB"
  option "without-tests", "Build without accuracy & performance tests"
  option "without-opencl", "Disable GPU code in OpenCV using OpenCL"
  option "with-cuda", "Build with CUDA support"
  option "with-quicktime", "Use QuickTime for Video I/O insted of QTKit"
  option "with-opengl", "Build with OpenGL support"
  option "without-brewed-numpy", "Build without Homebrew-packaged NumPy"

  option :cxx11

  depends_on :ant if build.with? "java"
  depends_on "cmake"      => :build
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
  depends_on "qt"         => :optional
  depends_on "tbb"        => :optional

  depends_on :python      => :recommended
  depends_on "homebrew/python/numpy" if build.with? "brewed-numpy"

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
    py_ver = build.stable? ? "" : "2"

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
    args << "-DBUILD_TESTS=OFF" << "-DBUILD_PERF_TESTS=OFF" if build.without? "tests"
    args << "-DBUILD_opencv_python#{py_ver}=" + arg_switch("python")
    args << "-DBUILD_opencv_java=" + arg_switch("java")
    args << "-DWITH_OPENEXR="   + arg_switch("openexr")
    args << "-DWITH_EIGEN="     + arg_switch("eigen")
    args << "-DWITH_TBB="       + arg_switch("tbb")
    args << "-DWITH_FFMPEG="    + arg_switch("ffmpeg")
    args << "-DWITH_QUICKTIME=" + arg_switch("quicktime")
    args << "-DWITH_1394="      + arg_switch("libdc1394")
    args << "-DWITH_OPENGL="    + arg_switch("opengl")
    args << "-DWITH_JASPER="    + arg_switch("jasper")
    args << "-DWITH_QT="        + arg_switch("qt")
    args << "-DWITH_GSTREAMER=" + arg_switch("gstreamer")

    if build.with? "python"
      py_prefix = `python-config --prefix`.chomp
      py_lib = OS.linux? ? `python-config --configdir`.chomp : "#{py_prefix}/lib"
      args << "-DPYTHON#{py_ver}_LIBRARY=#{py_lib}/libpython2.7.#{dylib}"
      args << "-DPYTHON#{py_ver}_INCLUDE_DIR=#{py_prefix}/include/python2.7"
    end

    if build.with? "cuda"
      ENV["CUDA_NVCC_FLAGS"] = "-Xcompiler -stdlib=libstdc++; -Xlinker -stdlib=libstdc++"
      inreplace "cmake/FindCUDA.cmake",
        "list(APPEND CUDA_LIBRARIES -Wl,-rpath \"-Wl,${_cuda_path_to_cudart}\")",
        "#list(APPEND CUDA"
      args << "-DWITH_CUDA=ON"
      args << "-DCMAKE_CXX_FLAGS=-stdlib=libstdc++"
    else
      args << "-DWITH_CUDA=OFF"
    end

    # OpenCL 1.1 is required, but Snow Leopard and older come with 1.0
    args << "-DWITH_OPENCL=OFF" if build.without?("opencl") || MacOS.version < :lion

    if build.with? "openni"
      args << "-DWITH_OPENNI=ON"
      # Set proper path for Homebrew's openni
      inreplace "cmake/OpenCVFindOpenNI.cmake" do |s|
        s.gsub! "/usr/include/ni", "#{Formula["openni"].opt_include}/ni"
        s.gsub! "/usr/lib", "#{Formula["openni"].opt_lib}"
      end
    end

    if build.include? "32-bit"
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
      args << "-DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'"
      args << "-DOPENCV_EXTRA_CXX_FLAGS='-arch i386 -m32'"
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
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import cv2"
    end
  end
end


__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1d7d78a..1e92c52 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -135,7 +135,7 @@ OCV_OPTION(WITH_NVCUVID        "Include NVidia Video Decoding library support"
 OCV_OPTION(WITH_EIGEN          "Include Eigen2/Eigen3 support"               ON)
 OCV_OPTION(WITH_VFW            "Include Video for Windows support"           ON   IF WIN32 )
 OCV_OPTION(WITH_FFMPEG         "Include FFMPEG support"                      ON   IF (NOT ANDROID AND NOT IOS))
-OCV_OPTION(WITH_GSTREAMER      "Include Gstreamer support"                   ON   IF (UNIX AND NOT APPLE AND NOT ANDROID) )
+OCV_OPTION(WITH_GSTREAMER      "Include Gstreamer support"                   ON   IF (UNIX AND NOT ANDROID) )
 OCV_OPTION(WITH_GSTREAMER_0_10 "Enable Gstreamer 0.10 support (instead of 1.x)"   OFF )
 OCV_OPTION(WITH_GTK            "Include GTK support"                         ON   IF (UNIX AND NOT APPLE AND NOT ANDROID) )
 OCV_OPTION(WITH_IMAGEIO        "ImageIO support for OS X"                    OFF  IF APPLE )

class Opencv < Formula
  desc "Open Source Computer Vision Library"
  homepage "http://opencv.org/"
  head "https://github.com/Itseez/opencv.git"

  stable do
    url "https://github.com/Itseez/opencv/archive/3.0.0.tar.gz"
    sha256 "da51a4e459b0bcbe14fb847c4f168415f421765fb91996f42b9e1ce0575f05d5"

    resource "icv-macosx" do
      url "https://downloads.sourceforge.net/project/opencvlibrary/3rdparty/ippicv/ippicv_macosx_20141027.tgz", :using => :nounzip
      sha256 "07e9ae595154f1616c6c3e33af38695e2f1b0c99c925b8bd3618aadf00cd24cb"
    end

    resource "icv-linux" do
      url "https://downloads.sourceforge.net/project/opencvlibrary/3rdparty/ippicv/ippicv_linux_20141027.tgz", :using => :nounzip
      sha256 "a5669b0e3b500ee813c18effe1de2477ef44af59422cf7f8862a360f3f821d80"
    end
  end

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "15160718f0baa14ff5ffdfdcb7fe27ee1980ff5388275c743eda9e7fa65730f1" => :yosemite
    sha256 "eed5669d5840aa0ead8e36fb9f421b47f69ddb99cfdd7acdc16a40128198acc1" => :mavericks
    sha256 "6b113f9d44eee1ce6681dda5d1411cb9a0f981e0efd9403e216e848ae18df605" => :mountain_lion
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
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-python", "Build without Python support"

  deprecated_option "without-brewed-numpy" => "without-numpy"

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
      # Make sure find_program locates system Python
      # https://github.com/Homebrew/homebrew-science/issues/2302
      args << "-DCMAKE_PREFIX_PATH=#{py_prefix}" if OS.mac?
    end

    if build.with? "cuda"
      ENV["CUDA_NVCC_FLAGS"] = "-Xcompiler -stdlib=libstdc++; -Xlinker -stdlib=libstdc++"
      args << "-DWITH_CUDA=ON"
      args << "-DCMAKE_CXX_FLAGS=-stdlib=libstdc++"
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

    inreplace buildpath/"3rdparty/ippicv/downloader.cmake",
      "${OPENCV_ICV_PLATFORM}-${OPENCV_ICV_PACKAGE_HASH}",
      "${OPENCV_ICV_PLATFORM}"
    platform = OS.mac? ? "macosx" : "linux"
    resource("icv-#{platform}").stage buildpath/"3rdparty/ippicv/downloads/#{platform}"

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
  end
end

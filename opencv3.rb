class Opencv3 < Formula
  desc "Open source computer vision library, version 3"
  homepage "http://opencv.org/"

  stable do
    url "https://github.com/Itseez/opencv/archive/3.0.0.tar.gz"
    sha256 "da51a4e459b0bcbe14fb847c4f168415f421765fb91996f42b9e1ce0575f05d5"

    resource "contrib" do
      url "https://github.com/Itseez/opencv_contrib/archive/3.0.0.tar.gz"
      sha256 "8fa18564447a821318e890c7814a262506dd72aaf7721c5afcf733e413d2e12b"
    end
  end
  bottle do
    sha256 "52eb80230c4958f5240a16bcb9bf0930fd25a95b84b0fcbc96ec21e4f6e9bb68" => :yosemite
    sha256 "01b822e8e75578b195c1a5edb69ceb4d16ed4e57f652505032c46bb15af3433d" => :mavericks
    sha256 "6d7a0737b6995f22151d7b20e9cac205aaa325cd5abd365190b939fe5a3af9c3" => :mountain_lion
  end


  head do
    url "https://github.com/Itseez/opencv.git"

    resource "contrib" do
      url "https://github.com/Itseez/opencv_contrib.git"
    end
  end

  keg_only "opencv3 and opencv install many of the same files."

  option "32-bit"
  option "with-contrib", 'Build "extra" contributed modules'
  option "with-cuda", "Build with CUDA v7.0+ support"
  option "with-java", "Build with Java support"
  option "with-opengl", "Build with OpenGL support (must use --with-qt5)"
  option "with-quicktime", "Use QuickTime for Video I/O instead of QTKit"
  option "with-qt", "Build the Qt4 backend to HighGUI"
  option "with-qt5", "Build the Qt5 backend to HighGUI"
  option "with-tbb", "Enable parallel code in OpenCV using Intel TBB"
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-opencl", "Disable GPU code in OpenCV using OpenCL"
  option "without-python", "Build without Python support"
  option "without-tests", "Build without accuracy & performance tests"

  option :cxx11

  depends_on :ant => :build if build.with? "java"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "eigen" => :recommended
  depends_on "ffmpeg" => :optional
  depends_on "gphoto2" => :optional
  depends_on "gstreamer" => :optional
  depends_on "gst-plugins-good" if build.with? "gstreamer"
  depends_on "jasper" => :optional
  depends_on :java => :optional
  depends_on "jpeg"
  depends_on "libdc1394" => :optional
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr" => :recommended
  depends_on "openni" => :optional
  depends_on "openni2" => :optional
  depends_on :python => :recommended unless OS.mac? && MacOS.version > :snow_leopard
  depends_on :python3 => :optional
  depends_on "qt" => :optional
  depends_on "qt5" => :optional
  depends_on "tbb" => :optional

  with_python = build.with?("python") || build.with?("python3")
  pythons = build.with?("python3") ? ["with-python3"] : []
  depends_on "homebrew/python/numpy" => [:recommended] + pythons if with_python

  # dependencies use fortran, which leads to spurious messages about gcc
  cxxstdlib_check :skip

  resource "icv-macosx" do
    url "https://downloads.sourceforge.net/project/opencvlibrary/3rdparty/ippicv/ippicv_macosx_20141027.tgz", :using => :nounzip
    sha256 "07e9ae595154f1616c6c3e33af38695e2f1b0c99c925b8bd3618aadf00cd24cb"
  end

  resource "icv-linux" do
    url "https://downloads.sourceforge.net/project/opencvlibrary/3rdparty/ippicv/ippicv_linux_20141027.tgz", :using => :nounzip
    sha256 "a5669b0e3b500ee813c18effe1de2477ef44af59422cf7f8862a360f3f821d80"
  end

  def arg_switch(opt)
    (build.with? opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?
    jpeg = Formula["jpeg"]
    dylib = OS.mac? ? "dylib" : "so"
    with_qt = build.with?("qt") || build.with?("qt5")

    args = std_cmake_args + %W[
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_PNG=OFF
      -DBUILD_ZLIB=OFF
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DJPEG_INCLUDE_DIR=#{jpeg.opt_include}
      -DJPEG_LIBRARY=#{jpeg.opt_lib}/libjpeg.#{dylib}
    ]
    args << "-DBUILD_opencv_java=" + arg_switch("java")
    args << "-DBUILD_opencv_python2=" + arg_switch("python")
    args << "-DBUILD_opencv_python3=" + arg_switch("python3")
    args << "-DBUILD_TESTS=OFF" << "-DBUILD_PERF_TESTS=OFF" if build.without? "tests"
    args << "-DWITH_1394=" + arg_switch("libdc1394")
    args << "-DWITH_EIGEN=" + arg_switch("eigen")
    args << "-DWITH_FFMPEG=" + arg_switch("ffmpeg")
    args << "-DWITH_GPHOTO2=" + arg_switch("gphoto2")
    args << "-DWITH_GSTREAMER=" + arg_switch("gstreamer")
    args << "-DWITH_JASPER=" + arg_switch("jasper")
    args << "-DWITH_OPENEXR=" + arg_switch("openexr")
    args << "-DWITH_OPENGL=" + arg_switch("opengl")
    args << "-DWITH_QUICKTIME=" + arg_switch("quicktime")
    args << "-DWITH_QT=" + (with_qt ? "ON" : "OFF")
    args << "-DWITH_TBB=" + arg_switch("tbb")

    if build.include? "32-bit"
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
      args << "-DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'"
      args << "-DOPENCV_EXTRA_CXX_FLAGS='-arch i386 -m32'"
    end

    if build.with? "cuda"
      args << "-DWITH_CUDA=ON"
      args << "-DCUDA_GENERATION=Kepler"
    else
      args << "-DWITH_CUDA=OFF"
    end

    if build.with? "contrib"
      resource("contrib").stage buildpath/"opencv_contrib"
      args << "-DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules"
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

    if build.with? "openni2"
      args << "-DWITH_OPENNI2=ON"
      ENV["OPENNI2_INCLUDE"] ||= "#{Formula["openni2"].opt_include}/ni2"
      ENV["OPENNI2_REDIST"] ||= "#{Formula["openni2"].opt_lib}/ni2"
    end

    if build.with? "python"
      py_prefix = `python-config --prefix`.chomp
      py_lib = OS.linux? ? `python-config --configdir`.chomp : "#{py_prefix}/lib"
      args << "-DPYTHON2_EXECUTABLE=#{which "python"}"
      args << "-DPYTHON2_LIBRARY=#{py_lib}/libpython2.7.#{dylib}"
      args << "-DPYTHON2_INCLUDE_DIR=#{py_prefix}/include/python2.7"
    end

    if build.with? "python3"
      py3_config = `python3-config --configdir`.chomp
      py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
      py3_version = Language::Python.major_minor_version "python3"
      args << "-DPYTHON3_LIBRARY=#{py3_config}/libpython#{py3_version}.#{dylib}"
      args << "-DPYTHON3_INCLUDE_DIR=#{py3_include}"
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

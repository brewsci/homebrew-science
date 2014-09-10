require 'formula'

class Opencv < Formula
  homepage 'http://opencv.org/'
  url 'https://github.com/Itseez/opencv/archive/2.4.9.tar.gz'
  sha1 'd16ced627db17f9864c681545f18f030c7a4cc0b'
  head 'https://github.com/Itseez/opencv.git'

  option "32-bit"
  option "with-java", "Build with Java support"
  option "with-qt", "Build the Qt4 backend to HighGUI"
  option "with-tbb", "Enable parallel code in OpenCV using Intel TBB"
  option "with-tests", "Build with accuracy & performance tests"
  option "without-opencl", "Disable GPU code in OpenCV using OpenCL"
  option "with-cuda", "Build with CUDA support"
  option "with-quicktime", "Use QuickTime for Video I/O insted of QTKit"

  option :cxx11

  depends_on :ant if build.with? "java"
  depends_on "cmake"      => :build
  depends_on "eigen"      => :optional
  depends_on "gstreamer"  => :optional
  depends_on "jasper"     => :optional
  depends_on "jpeg"
  depends_on :libpng
  depends_on "libtiff"
  depends_on "libdc1394"  => :optional
  depends_on "numpy"      => :python
  depends_on "openexr"    => :recommended
  depends_on "openni"     => :optional
  depends_on "pkg-config" => :build
  depends_on :python
  depends_on "qt"         => :optional
  depends_on "tbb"        => :optional

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway. Will depend on openexr if it's installed.
  depends_on 'ffmpeg' => :optional

  def install
    jpeg = Formula["jpeg"]
    py_prefix = %x(python-config --prefix).chomp
    py_version = %x(python -c "import sys; print(sys.version)")[0..2]

    ENV.cxx11 if build.cxx11?
    args = std_cmake_args + %W(
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_ZLIB=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_PNG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DJPEG_INCLUDE_DIR=#{jpeg.opt_include}
      -DJPEG_LIBRARY=#{jpeg.opt_lib}/libjpeg.dylib
      -DPYTHON_LIBRARY=#{py_prefix}/lib/libpython#{py_version}.dylib
      -DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{py_version}
    )

    if build.without? "tests"
      args << "-DBUILD_TESTS=OFF" << "-DBUILD_PERF_TESTS=OFF"
    end

    args << "-DBUILD_opencv_java=" + ((build.with? "java") ? "ON" : "OFF")
    args << "-DWITH_OPENEXR=" + ((build.with? "openexr") ? "ON" : "OFF")
    args << "-DWITH_QT=" + ((build.with? "qt") ? "ON" : "OFF")
    args << "-DWITH_TBB=" + ((build.with? "tbb") ? "ON" : "OFF")
    args << "-DWITH_FFMPEG=" + ((build.with? "ffmpeg") ? "ON" : "OFF")
    args << "-DWITH_GSTREAMER=" + ((build.with? "gstreamer") ? "ON" : "OFF")
    args << "-DWITH_QUICKTIME=" + ((build.with? "quicktime") ? "ON" : "OFF")
    args << "-DWITH_1394=" + ((build.with? "libdc1394") ? "ON" : "OFF")

    if build.with? "cuda"
      args << "-DWITH_CUDA=ON"
      args << "-DCMAKE_CXX_FLAGS=-stdlib=libstdc++"
    else
      args << "-DWITH_CUDA=OFF"
    end

    # OpenCL 1.1 is required, but Snow Leopard and older come with 1.0
    args << "-DWITH_OPENCL=OFF" if build.without? "opencl" or MacOS.version < :lion

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

    if ENV.compiler == :clang and !build.bottle?
      args << '-DENABLE_SSSE3=ON' if Hardware::CPU.ssse3?
      args << '-DENABLE_SSE41=ON' if Hardware::CPU.sse4?
      args << '-DENABLE_SSE42=ON' if Hardware::CPU.sse4_2?
      args << '-DENABLE_AVX=ON' if Hardware::CPU.avx?
    end

    mkdir "macbuild" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

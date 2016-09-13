require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.1.tar.bz2"
  sha256 "242f3b8fbc857621d36b5c3f0b32659a9c9e9adccba794cd82d230aa1adb575c"
  revision 2

  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "9871c5e7578d41b84c49dcc7741f32faaf45abb8a43c2735be031cb5a1902cd5" => :el_capitan
    sha256 "6a412c4e11718bc67f16b78b9f2166fe8444255d16f6ba380465080081d140bc" => :yosemite
    sha256 "5f3c699b192772ba7990ce4ca19a45ecca7c241d36e546b4092b24bdbfd7f957" => :mavericks
  end

  depends_on CudaRequirement => :optional

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas" => :optional
  depends_on "libpng"
  depends_on "zlib" unless OS.mac?
  depends_on :x11

  needs :cxx11

  # remove patch at next release
  patch do
    url "https://github.com/davisking/dlib/commit/114d156daee8e11c7e6ebf907e4b147a998226f0.patch"
    sha256 "18687e9078222bbb97ba5e43086707b0efddc7778d79567cc5d21faa20faceaa"
  end unless build.head?

  def install
    ENV.cxx11
    so = OS.mac? ? "dylib" : "so"
    args = std_cmake_args
    args << "-DUSE_AVX_INSTRUCTIONS=1" if Hardware::CPU.avx?

    args << "-DDLIB_USE_BLAS=ON" << "-DDLIB_USE_LAPACK=ON"
    if build.with? "openblas"
      args << "-Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.#{so}"
      args << "-Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.#{so}"
    elsif OS.mac?
      args << "-Dcblas_lib=/usr/lib/libcblas.dylib"
      args << "-Dlapack_lib=/usr/lib/liblapack.dylib"
      # otherwise, fingers crossed that libblas and liblapack are detected
    end

    args << "-DDLIB_USE_CUDA=ON" if build.with? "cuda"

    cd "dlib" do
      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end
    pkgshare.install "examples"
    doc.install "docs"
  end

  test do
    ENV.cxx11
    cp pkgshare/"examples/faces/2007_007763.jpg", testpath
    (testpath/"face_detection.cpp").write <<-EOS.undent
    #include <dlib/image_processing/frontal_face_detector.h>
    #include <dlib/image_io.h>
    #include <iostream>

    using namespace dlib;
    using namespace std;

    int main(int argc, char** argv) {
      frontal_face_detector detector = get_frontal_face_detector();

      array2d<unsigned char> img;
      load_image(img, argv[1]);
      pyramid_up(img);
      std::vector<rectangle> dets = detector(img);
      cout << dets.size() << endl;
    }
    EOS
    cxx_with_args = ENV.cxx.split + %W[
      face_detection.cpp
      -I#{opt_include}
      -o face_detection
      -L#{opt_lib} -ldlib
    ]

    # include BLAS library again to avoid undefined symbol cblas_saxpy error
    if Tab.for_name("dlib").with?("openblas")
      cxx_with_args << "-L#{Formula["openblas"].opt_lib}" << "-lopenblas"
    else
      cxx_with_args << "-lblas" << "-llapack"
    end

    system *cxx_with_args
    assert_equal `./face_detection 2007_007763.jpg`.to_i, 7
  end
end

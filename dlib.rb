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
    sha256 "9a34eac9abaa1226add72580c89d1a97954265b6e893316fb65b52c501c99ecf" => :el_capitan
    sha256 "12eff0a69cbe664cecd9c67b922451bdad0910397eaf106eea282ea786690e4f" => :yosemite
    sha256 "d8c990e282b0b42fc17597c74f70163589d819785c8806989a9a157f9831c9eb" => :mavericks
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

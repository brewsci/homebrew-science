require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.2.tar.bz2"
  sha256 "28be8f96681e0fd196a7666ad1e1fa6994e9494aef737dd7d6985a3f1620084a"

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
    cd "examples" do
      system "cmake", "."
      system "make"
    end
    pkgshare.install "examples"
    doc.install "docs"
  end

  test do
    cp pkgshare/"examples/kcentroid_ex", testpath
    system "./kcentroid_ex"
  end
end

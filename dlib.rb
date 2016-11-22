require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.2.tar.bz2"
  sha256 "28be8f96681e0fd196a7666ad1e1fa6994e9494aef737dd7d6985a3f1620084a"

  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "1dff22ee66d1be9d2277dd76a10b8d4394340dc618a5b3683f6b22e2264fe018" => :sierra
    sha256 "ed3f6f83daa72272cc1d3acd53785ebb55ee8ddfba81143b48b52e3ad15e68a2" => :el_capitan
    sha256 "0da49a88691ebf762626c0475de0e3a569851a92ef010646cfeb1d9f4b671f6b" => :yosemite
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

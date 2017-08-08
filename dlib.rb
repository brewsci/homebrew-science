require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.4.tar.bz2"
  sha256 "003f0508fe605cf397ad678c6976e5ec7db8472faabf06508d16ead205571372"
  revision 1

  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any
    sha256 "e8e54efcee04ca2d97bd94c8c5eaef7a4c397721b3d47d8d91f9549805ef1c21" => :sierra
    sha256 "c789f675a4846c24286e0277dfe0a0005281fd0d4c108d9f2687d53ecf4e0151" => :el_capitan
    sha256 "abfb6e9cb95ac8c38834beb4854a3669ee533aa5661f532ca7d401b1500fea36" => :x86_64_linux
  end

  depends_on :macos => :el_capitan # needs thread-local storage
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

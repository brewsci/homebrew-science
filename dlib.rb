class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"

  url "http://dlib.net/files/dlib-19.1.tar.bz2"
  sha256 "242f3b8fbc857621d36b5c3f0b32659a9c9e9adccba794cd82d230aa1adb575c"

  bottle do
    cellar :any
    sha256 "e020c1f9554ab1e8f21ec2badb46f339fa729f52d1e0d207cbc7741dcbf3b159" => :el_capitan
    sha256 "f3e2feb3e403ee8b64aa4338462815ea958be25b9a901beda43190730f7bcf15" => :yosemite
    sha256 "70cb278bfab84c3d0720815145ecbce59aafe8a887c99268b4b15da3186dd9c1" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "libpng"
  depends_on "zlib" unless OS.mac?
  depends_on :x11

  def install
    cd "dlib" do
      args = std_cmake_args
      args << "-DUSE_AVX_INSTRUCTIONS=1" if Hardware::CPU.avx?
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
    # no test yet, just the library
  end
end

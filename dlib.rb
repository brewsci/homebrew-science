class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"

  url "http://dlib.net/files/dlib-19.1.tar.bz2"
  sha256 "242f3b8fbc857621d36b5c3f0b32659a9c9e9adccba794cd82d230aa1adb575c"

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

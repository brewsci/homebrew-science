class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.1.1.tar.gz"
  sha256 "66bb18d752f98f4ea53f774de7d28dfea41b8c8896bd01bce1ee1231f9cc7249"

  bottle do
    cellar :any
    sha256 "cf84415dc145a1a160ff8b5ee22a54115837e6d5670b8adb15f011bf64a1180c" => :sierra
    sha256 "b3a43c8f06bbc09916e9c270068a9aae2d93f443f39d3f2299fb675dd335047d" => :el_capitan
    sha256 "830fd43ff3c55cb6de8629b9fad79ffc1cf3a783a8c2c41026e4f9fa0dd42279" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "curl"
  depends_on "libxslt"
  depends_on "raptor"

  def install
    system "cmake", ".", "-DSBOL_BUILD_SHARED=TRUE", "-DSBOL_BUILD_STATIC=FALSE", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    EOS
    if ENV.compiler == :gcc
      system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{HOMEBREW_PREFIX}/include/curl", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/raptor2", "-I#{include}/sbol", "-L#{HOMEBREW_PREFIX}/lib", "-L#{lib}", "-Wl,-rpath=#{HOMEBREW_PREFIX}/lib,-rpath=#{lib}", "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    else
      system ENV.cc, "test.cpp", "-o", "test", "-std=c++11", "-I#{HOMEBREW_PREFIX}/include/curl", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/raptor2", "-I#{include}/sbol", "-L#{HOMEBREW_PREFIX}/lib", "-L#{lib}", "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol", "-lc++"
    end
    system "./test"
  end
end

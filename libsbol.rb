class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.1.1.1.tar.gz"
  sha256 "76a9895e779bca91a617af885de7b411d4203f571306c3a69942913e1bdaf3ac"

  bottle do
    cellar :any
    sha256 "3b14c0ef78a7782ce8f5f1ef75afa0cd072ce1aa20f1b0d8f2f561c6b0c47268" => :sierra
    sha256 "0aea30e7f928ba7ba93b5c0e4d3567be4440ca1fa4279cc3674ae081a1e597ac" => :el_capitan
    sha256 "a8f369624ac2eef8b6e6615a4734d1ca97c9060f60b07adb821fee4a553a2f51" => :yosemite
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

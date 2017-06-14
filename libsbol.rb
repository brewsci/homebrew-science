class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.2.0.2.tar.gz"
  sha256 "6df9066c05b13dc4fae9ff2bace4a084e434a25bb311ce88d2fc3aed4b79ea37"

  bottle do
    cellar :any
    sha256 "f75a14211394ced3c638029becb5475b7a7acf044e476ddac64f3633ea13dd02" => :sierra
    sha256 "83dd5e576cbd700214b214549e166335fb63cc8ae52f33dd56393bc742de085d" => :el_capitan
    sha256 "6c8960f360f07339e63a713a58bdbdaa970ca5b79abb93fc8200f3bbf9199506" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "curl"
  depends_on "libxslt"
  depends_on "raptor"

  def install
    system "cmake", ".", "-DCMAKE_CXX_FLAGS=-I/System/Library/Frameworks/Python.framework/Headers",
                         "-DSBOL_BUILD_SHARED=TRUE", "-DSBOL_BUILD_STATIC=FALSE", *std_cmake_args
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
      system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I/System/Library/Frameworks/Python.framework/Headers", "-I#{HOMEBREW_PREFIX}/include/curl", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/raptor2", "-I#{include}/sbol", "-L#{HOMEBREW_PREFIX}/lib", "-L#{lib}", "-Wl,-rpath=#{HOMEBREW_PREFIX}/lib,-rpath=#{lib}", "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    else
      system ENV.cc, "test.cpp", "-o", "test", "-std=c++11", "-I/System/Library/Frameworks/Python.framework/Headers", "-I#{HOMEBREW_PREFIX}/include/curl", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/raptor2", "-I#{include}/sbol", "-L#{HOMEBREW_PREFIX}/lib", "-L#{lib}", "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol", "-lc++"
    end
    system "./test"
  end
end

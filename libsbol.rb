class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.2.0.tar.gz"
  sha256 "f171a1dadcb1414b763a626a83ca1874230b6e4dd7483a8c9526fcf0137d44a9"

  bottle do
    cellar :any
    sha256 "2bbc0a976c014dae9236840be15b957e018bebeeac3efc833fec96bcf06fcc83" => :sierra
    sha256 "9985b9c5c1620baf6d414e51aa618a3621c88abc0cee9796592cad2d2e9c4586" => :el_capitan
    sha256 "9532b17e32966ef97c6bb612a81ed58f2dde4bdee0d76836c1cc71ea468d78b5" => :yosemite
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

class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.500.1.tar.xz"
  sha256 "7d790ee5825caaab4ef29da2746aa1dc4d5fa1a555e13306b8894a487da1f5a4"

  bottle do
    cellar :any
    sha256 "0fa92f5ad19a9ab4468867f4f2571b9480027a3620bde69823be89f47ddfe354" => :sierra
    sha256 "f2e434fa136319d7b035223d2c676ff0204202e60b3a7ac38012c36ac2935a93" => :el_capitan
    sha256 "706db3fa9f63ff9bbfb212fa1aac534707854ffef7418a1a4226c8cbe6908557" => :yosemite
  end

  option "with-hdf5", "Enable the ability to save and load matrices stored in the HDF5 format"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "superlu"
  depends_on "hdf5" => :optional
  depends_on "openblas" if OS.linux?

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?

    if build.with? "hdf5"
      inreplace "CMakeLists.txt", "project(armadillo CXX)",
                                  "project(armadillo CXX)\nENABLE_LANGUAGE(C)"
    end

    args = std_cmake_args
    args << "-DDETECT_HDF5=ON" if build.with? "hdf5"

    system "cmake", ".", *args
    system "make", "install"

    prefix.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <iostream>
      #include <armadillo>
      using namespace std;
      using namespace arma;

      int main(int argc, char** argv)
        {
        cout << arma_version::as_string() << endl;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal `./test`.to_i, version.to_s.to_i
  end
end

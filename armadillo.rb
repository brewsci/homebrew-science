class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.200.2.tar.xz"
  sha256 "55ab2e62e305da66de6e1c80d91a55511a924cbcfa95ceb13c87e8a958397dfb"

  bottle do
    cellar :any
    sha256 "58425d1c9279d4c9ef24f5b8b187845ab6fa8e8f13ba8d6ea0408ca85a2af221" => :el_capitan
    sha256 "96deaeb1f5337a6f362179805ddfff901300a54e29845e7ca33fd071928b4860" => :yosemite
    sha256 "92cbf7021e7df823e636373d4867fdd185cd982f960e83419872b64cc9ae3236" => :mavericks
  end

  option "with-hdf5", "Enable the ability to save and load matrices stored in the HDF5 format"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "superlu43"
  depends_on "hdf5" => :optional
  depends_on "openblas" if OS.linux?

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?

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

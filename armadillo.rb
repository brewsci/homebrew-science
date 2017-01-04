class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.600.2.tar.xz"
  sha256 "6790d5e6b41fcac6733632a9c3775239806d00178886226dec3f986a884f4c2d"

  bottle do
    cellar :any
    sha256 "9c3b2f5bcc7da2c6af90f8da2fd81f511d6a9700dcfea01376c9af3c8e36805b" => :sierra
    sha256 "4ef4b851eb2b2eccb783972f8388bb4f107a4ece77f7c3d1460b75dad7a476c4" => :el_capitan
    sha256 "7330c877d626a03fc2a3d8ca407846eea5f724f3fa0122b60eaf7a659afbff3f" => :yosemite
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

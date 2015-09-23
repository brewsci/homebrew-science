class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.600.2.tar.gz"
  sha256 "3a4e16f07dddd16313128eb1cab8e2f257d7461bde4a1d277c85181dcd6d1eda"
  revision 1

  bottle do
    cellar :any
    sha256 "9329ab8f224cd293036b1c6258ed2c3a3c324d8eabe03758e2d06295f29a21b9" => :yosemite
    sha256 "edb5d907e9b6bb4c0088a70d11029446fa306c0d1310634181d38bb1483e7b85" => :mavericks
    sha256 "9c499df6791cafa6f9e443a7b81c9e5f511c8070f866dca7388d9805c8b10377" => :mountain_lion
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

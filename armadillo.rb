class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.600.2.tar.gz"
  sha256 "3a4e16f07dddd16313128eb1cab8e2f257d7461bde4a1d277c85181dcd6d1eda"
  revision 1

  bottle do
    cellar :any
    sha256 "c663bcbadbe2a5ca8c25562cd9babafeb06d29b828fe81d4e68a039aa64ab997" => :el_capitan
    sha256 "b310fdee684fb1a371b593b285c96a7b23da8863f95e7beea0b1fb7f66b7a9f4" => :yosemite
    sha256 "abe9121ca6e00eb1c4408b4594d3a5f5f891fabe3db56122f337821e93dd1681" => :mavericks
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

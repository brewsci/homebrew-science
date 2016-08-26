class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.400.2.tar.xz"
  sha256 "e4cdac83a7a271da5b503d7cb3f1da9a2c4419905979a9350d99d75421b6b776"

  bottle do
    cellar :any
    sha256 "98f855a104bb32d187df1cbcc501e23e126d78241db9362f621eed6bda25fccc" => :el_capitan
    sha256 "b3f69bb0d11f844e7a3a32475bb328817be8c3b04731b8915b68255def806ec1" => :yosemite
    sha256 "68634ca36b38d7f828cf6a4e08fc951dddf3c3c33e725953c36cd652f39f5cde" => :mavericks
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

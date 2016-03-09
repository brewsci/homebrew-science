class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-6.500.5.tar.gz"
  sha256 "eb1ffbcd779d3f158b541211ca1ed5111a0b9dd11157778978bb64e48067e5ee"

  bottle do
    cellar :any
    sha256 "0a6a35e79f02b3d938204cf47f644102d30a3964bb42d06dd361a4e7788dcc95" => :el_capitan
    sha256 "71857415ff89f87832a40bf1114dd1b37e9e2241e4f391a2bd8da35bff58591d" => :yosemite
    sha256 "4aea12b446ba0afd9d87cf62640824da81d6a06c4118ffdeac1dd8c5899786b4" => :mavericks
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

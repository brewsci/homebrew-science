class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-6.500.5.tar.gz"
  sha256 "eb1ffbcd779d3f158b541211ca1ed5111a0b9dd11157778978bb64e48067e5ee"

  bottle do
    cellar :any
    sha256 "e74fd812fd0341570439e0a70e26c8693844912cfb0658ce0c59dbea5912843b" => :el_capitan
    sha256 "05f4d062b58c1cbfca916e4146f458ba2f643a985b94c86a919c0112837e5bfd" => :yosemite
    sha256 "3af58f4c7fa6fe6c4408c3fb55b157b929e3862b3388b205cb616500d7edf4b3" => :mavericks
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

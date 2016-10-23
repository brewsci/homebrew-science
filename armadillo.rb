class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.400.2.tar.xz"
  sha256 "e4cdac83a7a271da5b503d7cb3f1da9a2c4419905979a9350d99d75421b6b776"

  bottle do
    cellar :any
    sha256 "ef109ae424529dce8019e1fcd8bbc202eaf4900faf807dd661f3fa25629eeefc" => :sierra
    sha256 "125a3829450eeaa9b4fa598ebcd40d212d73872fcedd6a39e7a6517441cc6b93" => :el_capitan
    sha256 "6d091e38500617c617358fe58d8a07f714ac7ad4e1b74708742c8577dbc28b25" => :yosemite
    sha256 "ec319822fea56e434d508d1325e8c95dc52da222e2d9bc64cbc087d7cfaacc99" => :mavericks
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

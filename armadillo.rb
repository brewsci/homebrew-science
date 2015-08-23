class Armadillo < Formula
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.400.2.tar.gz"
  sha256 "d155f50bcdd716e52c5c59ccba88adbedfa406f92b76b9edb7a84bd737dbff84"

  bottle do
    cellar :any
    sha256 "bba2c474a9982df8d905ccdd2920536a240ba7bd0dd146a37fa73a6c705cba9b" => :yosemite
    sha256 "ee88a8fcc4eb442bfa8aa2b8efac55f3e6e526f8b1b408e9aebd1ab83705c5d4" => :mavericks
    sha256 "f59558abbc48a4ceba38fb9a00afe3f002bf4b0e52af6d86cbb5180f8a3af7d2" => :mountain_lion
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

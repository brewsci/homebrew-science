class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.700.0.tar.xz"
  sha256 "f9029490f7edfb7029e117961db6307c2c3ee368691ed15e4fc58d06c9115d94"

  bottle do
    cellar :any
    sha256 "cfc6d95730df32d93d2e94d81273dfec908745a6a1529c05558a471b4d02e51e" => :sierra
    sha256 "c9b81c1cd6e537e2c8a036c40a8fb4f0f534755b9f66551d08c989bdbbbfec65" => :el_capitan
    sha256 "77ee64f69e324c007fb82c7e2165e3d4a94b9c7c7432797c16c51951e99be3f9" => :yosemite
  end

  option :cxx11

  option "with-hdf5", "Enable the ability to save and load matrices stored in the HDF5 format"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "superlu"
  depends_on "hdf5" => :optional
  depends_on "openblas" if OS.linux?

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

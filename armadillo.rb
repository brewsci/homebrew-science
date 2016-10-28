class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.500.0.tar.xz"
  sha256 "7aa6f82b226753b7a534cd77dffb08f82ecbcf60662aa1ea5a7ff5c7c46828f5"

  bottle do
    cellar :any
    sha256 "d2a7fe568b69ab22c5ae3d60eec22b7092324d4cdc2af5d74d4cadc995d0b2cc" => :sierra
    sha256 "25e838e741a5f1dda6ac13425965899a2b01179919a4a03cb6b9e8370f9811d9" => :el_capitan
    sha256 "7d081a8c0420c48d88baa4584fa0f1e0a88d216184522b0a72a66da9d9c51d38" => :yosemite
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

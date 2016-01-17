class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-6.400.3.tar.gz"
  sha256 "019ce442a1bcad4c5da0bc01ee35333c9a0783ec6a58237ae1e774da68cd4f2f"
  revision 1

  bottle do
    cellar :any
    sha256 "0b414c8d464de72d37c5b441d32d8fba6c8df774a547a9c57cc5fd2a87ef7c9b" => :el_capitan
    sha256 "fda152cc6a028bb3431354cdf1b5a0f97e630350d8255f65e5e688c4582e3dd2" => :yosemite
    sha256 "a97775beaef26d4a74da7a37a25b57f6aa5ff843006c41af7507073d54197d14" => :mavericks
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

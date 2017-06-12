class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.950.1.tar.xz"
  sha256 "a32da32a0ea420b8397a53e4b40ed279c1a5fc791dd492a2ced81ffb14ad0d1b"

  bottle do
    cellar :any
    sha256 "f4939714d766769c07d478357bbb566b315c568c7ef9955391738c9f835bbbb8" => :sierra
    sha256 "8ed46aea32a660baa5771460e1daa8802434a736e53d1011111e4fad21fb3b8b" => :el_capitan
    sha256 "0532cbdc768de8217a1f2a5c808bbe6ebe4a7b8c26e331075c9adc14492d003d" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "superlu"
  depends_on "openblas" if OS.linux?

  def install
    ENV.cxx11 if build.cxx11?

    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
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

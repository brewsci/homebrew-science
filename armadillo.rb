class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.800.1.tar.xz"
  sha256 "5ada65a5a610301ae188bb34f0ac6e7fdafbdbcd0450b0adb7715349ae14b8db"

  bottle do
    cellar :any
    sha256 "ee10b37cdd77f16ceaf626f0715349637eb0dd9f005d011eef404376aecded17" => :sierra
    sha256 "785c0e46daaa70c308755896d4ae322f2efa97eaa70b2d18a5ba720ef51f57b0" => :el_capitan
    sha256 "3c7213fb096c2b2a8c57ce2cb75438881fafcf2c2e7472ce29051b617e95e230" => :yosemite
    sha256 "d25f70e5c9f3bb7a4c1fca3c4a1d8cb04c421f661ef3a1ce3b29bac661821ab9" => :x86_64_linux
  end

  option :cxx11

  option "with-hdf5", "Enable the ability to save and load matrices stored in the HDF5 format"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

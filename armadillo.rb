class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.700.0.tar.xz"
  sha256 "f9029490f7edfb7029e117961db6307c2c3ee368691ed15e4fc58d06c9115d94"
  revision 1

  bottle do
    cellar :any
    sha256 "e6f122fa8ce4a8a923db7c3b5bf4f2aa6edcdd15d067db81b233f0e407e454bf" => :sierra
    sha256 "93fdd5f4255cdb2488bca8a1f708c34951c9f06b2f66c1e0c1b96e2646d29f12" => :el_capitan
    sha256 "042640eea38ed755d44df23d04168bb14cb90ff325141e284adbaa91e980043f" => :yosemite
    sha256 "2679deef1bd38c64aae06b7153cc28ee69cbbd509f3e9fd592ecb5b9fa9fe42a" => :x86_64_linux
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

class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.600.1.tar.xz"
  sha256 "f3a35c2a56dc706e9c413438d5b3063a0df2141515efaf2d1170d1944573afb7"

  bottle do
    cellar :any
    sha256 "392906601d4e2fc0f686dfd3114e2df7b3ce8ccc34f8031f3125c8f0bd58dd3c" => :sierra
    sha256 "e54b55258eafd8dd5453d394f53a2aeea3d46d14dce6a4a7710d6c7b40e081aa" => :el_capitan
    sha256 "80650c23b95941a2738f620239b16efd47572949155e122af08ee911d8d3cd92" => :yosemite
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

    if build.with? "hdf5"
      inreplace "CMakeLists.txt", "project(armadillo CXX)",
                                  "project(armadillo CXX)\nENABLE_LANGUAGE(C)"
    end

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

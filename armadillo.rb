class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.500.2.tar.xz"
  sha256 "bdde22b47cc9718a05762300828ba4e086aa0527970e4ce08eb08677fb2623ea"

  bottle do
    cellar :any
    sha256 "227a8d668ebb15f8da9f4337dfc059511d8a93feb6d9785f30662e90e74bdc79" => :sierra
    sha256 "37a86023b249de4a714f62ed3ace57dd6608738c857706d5f72bb5c2cdccab44" => :el_capitan
    sha256 "b6f062608bef23fb1a9daf80bc247f5a9820968a308d4b76b2503113b4446cb6" => :yosemite
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

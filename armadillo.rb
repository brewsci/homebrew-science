class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.800.2.tar.xz"
  sha256 "efd70600ab6f30449d90a3e58ff7499937985209bb0a03ce4e322474dbf11fe3"

  bottle do
    cellar :any
    sha256 "139b9394520eddb74b8dee45aa5008f774ea1a495f1f5cfbd3733ffe582eb42a" => :sierra
    sha256 "b0405d7aad5c196f50db14fb99c1f40fbd82fc6dfd65f127bc3e8b7dd83f9561" => :el_capitan
    sha256 "b1fec798f67559cac47f67297518d29f47de1288e96cc326b24bb5456b268d38" => :yosemite
    sha256 "27da3c2432833f3138bab75eb170d08ab1191a0318759155f4cc91801b087251" => :x86_64_linux
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

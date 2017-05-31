class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.950.0.tar.xz"
  sha256 "da89281959d48c60ce546dd370ef712ec1e24714e1e9afadad17dd2fbbc5876e"

  bottle do
    cellar :any
    sha256 "0dc626e12308d1cc3aefff4078cfc03d6cf750adcd5636c10664994bec215f61" => :sierra
    sha256 "30218dcb0043e75d0b603887826cfed44b3ba10cdc45054f8d1611fd13ee6a6f" => :el_capitan
    sha256 "e0f61540787645ce3fd7abd2fc993d417091b95495267627c7aa2d97f39e790e" => :yosemite
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

class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.950.0.tar.xz"
  sha256 "da89281959d48c60ce546dd370ef712ec1e24714e1e9afadad17dd2fbbc5876e"

  bottle do
    cellar :any
    sha256 "1d2abd10d3081ad594ac6fbe869c577c8302605b6c760a5709519ec6c6f1f484" => :sierra
    sha256 "1e67c6e7e2e19ca7d95eb4cc9dd3ab4a9c26412d71544f6d6eaf1d672d553512" => :el_capitan
    sha256 "e3d72320fa068c7ddb8e0d6beafdde2b751c3267c6619cc122115e9888fe27f1" => :yosemite
    sha256 "33699debc81c55d2d8e734c5663f89bdd497415d55c6a2e84178b14f14b673ca" => :x86_64_linux
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

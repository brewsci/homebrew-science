class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-6.100.0.tar.gz"
  sha256 "8ba581e5786ba04edefa4628574f6a68eec0f47ca15683ccd0a6354fc2381cc9"

  bottle do
    cellar :any
    sha256 "c0d8da2f4440026a434f472f24372d3b27aa70d8717c87d26271d44dc3f8cb31" => :el_capitan
    sha256 "40858b1da349d87bb6d1ad987c8900ad000eb81f063a13f03ec913f203a19523" => :yosemite
    sha256 "23939c2e9a60a5fe33ac34366753c2f65251b478ec7503b9171c12929c7d862c" => :mavericks
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

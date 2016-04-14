class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-6.700.4.tar.gz"
  sha256 "e9f1201cef34554de42e83d8237f56ced988c061399742c08356d0a22f934d37"

  bottle do
    cellar :any
    sha256 "45358e9a91491be468aec70ffecd4664d272afef9350fcaff35db239dfca840a" => :el_capitan
    sha256 "05c88c19311e1548702ac9e2d3158b9ac40023a738e414d71c96812f1561374d" => :yosemite
    sha256 "8b606c63c20b948902d979611fb14c82847bdd96dde4cf50d6f2149d68e1ea46" => :mavericks
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

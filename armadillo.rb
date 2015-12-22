class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-6.400.3.tar.gz"
  sha256 "019ce442a1bcad4c5da0bc01ee35333c9a0783ec6a58237ae1e774da68cd4f2f"

  bottle do
    cellar :any
    sha256 "c414586e28c73061e5cc7b5c28c63adaf88463e7c1d916538e58105415976991" => :el_capitan
    sha256 "9bd724225e0aa882e673470df77ac64cf139f75d862c40f5f78859f0bf761392" => :yosemite
    sha256 "b587e567ca1bcb9ccb876c93aeb2a836c64d8e4db318f5c953470c5afb264abf" => :mavericks
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

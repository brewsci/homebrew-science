class Armadillo < Formula
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.200.1.tar.gz"
  sha256 "3673fc7cbeefca826108efe7c36e21322f259809f874c161ca284a114fb7f693"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "b7ba1ac68d71bc8e91e2460d8f24174cd45df10488310f5625b7697c07f0c25a" => :yosemite
    sha256 "4972dd99d18c8fd9336b6ffc4434c70b6cd5a5c52224c0764eaee2c546e7440e" => :mavericks
    sha256 "cdbd4f24faf7d05b5abb7230ba4df222d5aeb853b69fb3596999e7a5b1e7f0c5" => :mountain_lion
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

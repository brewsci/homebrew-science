class Armadillo < Formula
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.200.1.tar.gz"
  sha256 "3673fc7cbeefca826108efe7c36e21322f259809f874c161ca284a114fb7f693"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "bf38ed1dd4ec537d5740ed8ad8fc9777fa20a663f9aaa722e2d02e4fad6934a9" => :yosemite
    sha256 "dbb1bb3caf03c9ed4faffc0e20ffcea251125cb430870ed9cea07b2f7735e682" => :mavericks
    sha256 "50321ecc405c92db73bf1aaccb540a0e31cce7b102fedb038af817b7702f9640" => :mountain_lion
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

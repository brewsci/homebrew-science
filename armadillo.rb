class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.600.2.tar.gz"
  sha256 "3a4e16f07dddd16313128eb1cab8e2f257d7461bde4a1d277c85181dcd6d1eda"

  bottle do
    cellar :any
    sha256 "a2e0953ab1b591fce524ee606c545a389adeb610f56383bee678a5db64f4d4c5" => :yosemite
    sha256 "17e9bebca7028204e819f473dadc62b8a46084fc8b30bcc057c8b9a744853591" => :mavericks
    sha256 "b9b0abf7b5f58a855fcb3be054eacd48c8212cb4f1a825c464ca126bad9fa458" => :mountain_lion
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

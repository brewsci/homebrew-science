class Armadillo < Formula
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-5.000.0.tar.gz"
  sha256 "23351f8ef031b9b34375d84bfc2df62cabd0631976ba697ff9716b64d0322eca"
  version "5.0.0"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "132ea8fc2806cc92e974d5047aea984c867916a7e301ae845cd4db87aab07ad2" => :yosemite
    sha256 "2e733759cf914864b181f6b43dd24278ba12626aa0965837637ba2d3c3094106" => :mavericks
    sha256 "013164528de9b672dab1679ac10e10dd3075d6eb29d28740091dd44f63f6a23d" => :mountain_lion
  end

  option "with-hdf5", "Enable the ability to save and load matrices stored in the HDF5 format"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "superlu"
  depends_on "openblas" if OS.linux?
  depends_on "hdf5" => :optional

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DDETECT_HDF5=ON" if build.with? "hdf5"

    system "cmake", ".", *args
    system "make", "install"

    # Copy examples/ directory to prefix
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
    assert `./test`.include?(version)
  end
end

require "formula"

class Armadillo < Formula
  homepage "http://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-4.600.2.tar.gz"
  sha1 "1b008706f52b154faeec3f6fcc8c98076ae9e5b9"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "6ac8d1aba88bbbd9ebedfc86a697d84d52af977c" => :yosemite
    sha1 "51b6727ac4eec80b9b1bf3ccd39267db4b4c63dd" => :mavericks
    sha1 "092c1cc5ad84f327b5953ea5f0107ffdea814e82" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "arpack"

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
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

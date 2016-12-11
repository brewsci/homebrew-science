class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms"
  homepage "http://dgtal.org"

  stable do
    url "http://dgtal.org/releases/DGtal-0.9.2-Source.tar.gz"
    mirror "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9.2-Source.tar.gz"
    sha256 "ba044b7c353a8550dc740c1d80e3caf59a76d4332d956599359027f3e8e20ed9"

    option "with-eigen32", "Build with eigen support"
    deprecated_option "with-eigen" => "with-eigen32"

    depends_on "homebrew/versions/eigen32" => :optional
  end

  bottle do
    cellar :any
    sha256 "22e98882123ba406271a0d0a32eb2f8c84929296c7a5f2b2485242bff645e2ae" => :el_capitan
    sha256 "10ca3bd949f1f1d4e400de0ac5180ba740f12e9628c07d4a63e8e1809bc12602" => :yosemite
    sha256 "b2ef6f45cd070b340cef5ab1fa395dd8f285784c12c7b75ac2bd080f4e3ee17a" => :mavericks
  end

  head do
    url "https://github.com/DGtal-team/DGtal.git"

    deprecated_option "with-eigen32" => "with-eigen"

    depends_on "eigen" => :optional
  end

  option "without-test", "Skip build-time tests"
  option "without-examples", "Don't build the examples"

  depends_on "cmake" => :build
  boost_args = []
  boost_args << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_args
  depends_on "gmp" => :optional
  depends_on "cairo" => :optional
  depends_on "graphicsmagick" => :optional
  depends_on "cgal" => [:optional, "with-eigen"]

  deprecated_option "with-magick" => "with-graphicsmagick"
  deprecated_option "with-qglviewer" => "with-libqglviewer"

  needs :cxx11

  # GCC 4 works, and according to upstream issue, GCC <= 5.2.1 may also be fine
  ["5", "6"].each do |n|
    fails_with :gcc => n do
      cause "testClone2 fails: https://github.com/DGtal-team/DGtal/issues/1203"
    end
  end

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_TESTING=ON" if build.with? "test"
    args << "-DBUILD_EXAMPLES=OFF" if build.without? "examples"
    args << "-DWITH_GMP=true" if build.with? "gmp"
    args << "-DWITH_CAIRO=true" if build.with? "cairo"
    args << "-DWITH_QGLVIEWER=true" if build.with? "libqglviewer"
    args << "-DWITH_MAGICK=true" if build.with? "graphicsmagick"

    if build.with?("eigen32") || build.with?("eigen")
      args << "-DWITH_EIGEN=true"
    end

    if build.with? "cgal"
      args << "-DWITH_EIGEN=true" << "-DWITH_GMP=true" << "-DWITH_CGAL=true"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    (testpath/"poly.cpp").write <<-EOS.undent
      #include "DGtal/io/readers/MPolynomialReader.h"
      using namespace std;
      using namespace DGtal;
      int main() {
        typedef double Ring;
        MPolynomial<3,Ring,std::allocator<Ring> > P;
        MPolynomialReader<3,Ring> reader;
        string str = "xyz^3-4yz";
        reader.read( P, str.begin(), str.end() );
        std::cout << P << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "poly.cpp", "-o", "poly", "-lDGtal", "-L#{lib}"
    output = shell_output("./poly xyz^3-4yz").chomp
    assert_equal "(-4 X_2 X_1 + 1 X_2^3 X_1 X_0)", output
  end
end

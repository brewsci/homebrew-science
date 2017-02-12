class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms"
  homepage "http://dgtal.org"
  url "http://dgtal.org/releases/DGtal-0.9.3-Source.tar.gz"
  mirror "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9.3-Source.tar.gz"
  sha256 "6ade39b5bf12b8da9b26df340830136d423fc4558b51ae5608cdac40e0fc1744"
  head "https://github.com/DGtal-team/DGtal.git"

  bottle do
    cellar :any
    sha256 "29c2686948449392c447391818a2ce46dd18ab120d7e405bc88bd804e02d5dfa" => :sierra
    sha256 "b7bfee3efbb877b36d24848b6bfb7296edce06f9cf2f71eb9b15c898314f37b6" => :el_capitan
    sha256 "3056f1b0a5aabce26dba1bbbfb15a1323106a6a3847fcc7c617299e38a218bb5" => :yosemite
  end

  option "without-test", "Skip build-time tests"
  option "without-examples", "Don't build the examples"

  deprecated_option "with-eigen@3.2" => "with-eigen"
  deprecated_option "with-eigen32" => "with-eigen"
  deprecated_option "with-magick" => "with-graphicsmagick"

  depends_on "cmake" => :build
  boost_args = []
  boost_args << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_args
  depends_on "eigen" => :optional
  depends_on "gmp" => :optional
  depends_on "cairo" => :optional
  depends_on "graphicsmagick" => :optional
  depends_on "cgal" => [:optional, "with-eigen"]

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
    args << "-DWITH_EIGEN=true" if build.with? "eigen"
    args << "-DWITH_GMP=true" if build.with? "gmp"
    args << "-DWITH_CAIRO=true" if build.with? "cairo"
    args << "-DWITH_MAGICK=true" if build.with? "graphicsmagick"

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

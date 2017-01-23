class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms"
  homepage "http://dgtal.org"
  revision 1

  stable do
    url "http://dgtal.org/releases/DGtal-0.9.2-Source.tar.gz"
    mirror "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9.2-Source.tar.gz"
    sha256 "ba044b7c353a8550dc740c1d80e3caf59a76d4332d956599359027f3e8e20ed9"

    option "with-eigen@3.2", "Build with eigen support"
    deprecated_option "with-eigen" => "with-eigen@3.2"

    depends_on "eigen@3.2" => :optional
  end

  bottle do
    cellar :any
    sha256 "29c2686948449392c447391818a2ce46dd18ab120d7e405bc88bd804e02d5dfa" => :sierra
    sha256 "b7bfee3efbb877b36d24848b6bfb7296edce06f9cf2f71eb9b15c898314f37b6" => :el_capitan
    sha256 "3056f1b0a5aabce26dba1bbbfb15a1323106a6a3847fcc7c617299e38a218bb5" => :yosemite
  end

  head do
    url "https://github.com/DGtal-team/DGtal.git"

    deprecated_option "with-eigen32" => "with-eigen"
    deprecated_option "with-eigen@3.2" => "with-eigen"

    depends_on "eigen" => :optional
  end

  option "without-test", "Skip build-time tests"
  option "without-examples", "Don't build the examples"

  deprecated_option "with-eigen32" => "with-eigen@3.2"
  deprecated_option "with-magick" => "with-graphicsmagick"
  deprecated_option "with-qglviewer" => "with-libqglviewer"

  depends_on "cmake" => :build
  boost_args = []
  boost_args << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_args
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
    args << "-DWITH_GMP=true" if build.with? "gmp"
    args << "-DWITH_CAIRO=true" if build.with? "cairo"
    args << "-DWITH_QGLVIEWER=true" if build.with? "libqglviewer"
    args << "-DWITH_MAGICK=true" if build.with? "graphicsmagick"

    if build.with?("eigen@3.2") || build.with?("eigen")
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

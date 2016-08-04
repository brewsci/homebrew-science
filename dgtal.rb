class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms Library (DGtal) is a toolkit to perform topology and geometry processing on (grid-based) digital data."
  homepage "http://dgtal.org"
  url "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9.1-Source.tar.gz"
  sha256 "9969eee23f0542d94f1a3f39b55665010baada65496223d671998f2c3eefb007"
  head "https://github.com/DGtal-team/DGtal.git"
  revision 2

  bottle do
    cellar :any
    sha256 "f5831beb33a43119f7ac61221514341b12003a43edc927671523b2abf1faeaf7" => :el_capitan
    sha256 "e56a577077e8db005ca89e71e7dd2dee7db8aa839f66864a47cdb385dc40de58" => :yosemite
    sha256 "6990e203f40c8061d689b7ef70486df5a4fe21e2ff49441365981e16c4e6aa69" => :mavericks
  end

  depends_on "cmake" => :build
  boost_args = []
  boost_args << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_args
  depends_on "gmp" => :optional
  depends_on "cairo" => :optional
  depends_on "libqglviewer" => :optional
  depends_on "graphicsmagick" => :optional
  depends_on "eigen" => :optional
  depends_on "cgal" => [:optional, "with-eigen3"]

  deprecated_option "with-magick" => "with-graphicsmagick"
  deprecated_option "with-qglviewer" => "with-libqglviewer"

  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DDGTAL_BUILD_TESTING=OFF"

    args << "-DWITH_GMP=true" if build.with? "gmp"
    args << "-DWITH_CAIRO=true" if build.with? "cairo"
    args << "-DWITH_QGLVIEWER=true" if build.with? "libqglviewer"
    args << "-DWITH_EIGEN=true" if build.with? "eigen"
    args << "-DWITH_MAGICK=true" if build.with? "graphicsmagick"
    args << "-DWITH_EIGEN=true -DWITH_GMP=true -DWITH_CGAL=true" if build.with? "cgal"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end
end

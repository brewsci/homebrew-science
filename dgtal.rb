class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms Library (DGtal) is a toolkit to perform topology and geometry processing on (grid-based) digital data."
  homepage "http://dgtal.org"
  url "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9-Source.tar.gz"
  sha256 "32190585e4b1bfaf275efa9c7007ed836676a06cf746f67b7f5f70f13f7e9b59"
  head "https://github.com/DGtal-team/DGtal.git"

  bottle do
    revision 1
    sha256 "3a315b3392ba9c91b69cfa30b6bd7fa7d9673c6b511aae64bcd69fb521d6ff7c" => :yosemite
    sha256 "7d7045432737c74713a2948892c9fefa2225270189db6bc50232a08de522158d" => :mavericks
    sha256 "f64ac070e869e50ff2593d72b7f6f291c0eb25e6f7d31bdfc41d582515e708bb" => :mountain_lion
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
      system "make",  "install"
    end
  end
end

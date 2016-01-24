class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms Library (DGtal) is a toolkit to perform topology and geometry processing on (grid-based) digital data."
  homepage "http://dgtal.org"
  url "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9.1-Source.tar.gz"
  sha256 "9969eee23f0542d94f1a3f39b55665010baada65496223d671998f2c3eefb007"
  head "https://github.com/DGtal-team/DGtal.git"

  bottle do
    cellar :any
    sha256 "16a75bbf9ff568dd0b0674ca30e80a2943575856b240da7a1d334d5e88b86555" => :el_capitan
    sha256 "8f723dcb858f5476c9a37c7e68e8873005cf77a850fda0723f12da690eb17885" => :yosemite
    sha256 "05b257da2d9393b7a5a3d80f853007acd355e368edbd7977a692f262911b48be" => :mavericks
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

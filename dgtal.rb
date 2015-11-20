class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms Library (DGtal) is a toolkit to perform topology and geometry processing on (grid-based) digital data."
  homepage "http://dgtal.org"
  url "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9-Source.tar.gz"
  sha256 "32190585e4b1bfaf275efa9c7007ed836676a06cf746f67b7f5f70f13f7e9b59"
  head "https://github.com/DGtal-team/DGtal.git"

  bottle do
    cellar :any
    sha256 "eb16fd70eb85bb4d67f8fbca66829a21a3a799ce92d38ad8da06a805f7feb29e" => :el_capitan
    sha256 "169e7ca264521b7f9083ad30b2affae9877b4e31642955b7629afde6c1a5decd" => :yosemite
    sha256 "b2258045c6d376da7c6267deab6722da8634bdedaf17e0c65b32fa7baf5cc53b" => :mavericks
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

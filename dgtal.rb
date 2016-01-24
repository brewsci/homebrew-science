class Dgtal < Formula
  desc "Digital Geometry Tools and Algorithms Library (DGtal) is a toolkit to perform topology and geometry processing on (grid-based) digital data."
  homepage "http://dgtal.org"
  url "http://liris.cnrs.fr/dgtal/releases/DGtal-0.9.1-Source.tar.gz"
  sha256 "9969eee23f0542d94f1a3f39b55665010baada65496223d671998f2c3eefb007"
  head "https://github.com/DGtal-team/DGtal.git"

  bottle do
    cellar :any
    sha256 "7fa1daca7de12c2734d4774d39a140b15afb890346172d8c5c01afe294de516b" => :el_capitan
    sha256 "da11c4acc1575ef5da06bd2f29e54902e4ba7bf6c70f099215651eb16935e792" => :yosemite
    sha256 "8f925cd6f43885f2035e06279a092f744ae6728172381363bdb22f63f6b29f57" => :mavericks
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

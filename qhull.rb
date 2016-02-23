class Qhull < Formula
  desc "Code for computing convex hulls in n dimensions."
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2015-src-7.2.0.tgz"
  version "2015.2"
  sha256 "78b010925c3b577adc3d58278787d7df08f7c8fb02c3490e375eab91bb58a436"

  bottle do
    cellar :any
    sha256 "0d2b4fad052a8b7d0200771c63066cbccaf9b0223972e52037944923ef1121d2" => :el_capitan
    sha256 "ac762982b59d0cf4e76ad68c9aec65c8d6f52dc18c0cac8b128c1292fded4b33" => :yosemite
    sha256 "65af0f0db6e96fb60705d384c155807d9bde4defa7aec6fe1b82e7c0faacbf40" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/rbox c D2 | #{bin}/qconvex s n"
  end
end

class Qhull < Formula
  desc "Qhull is a code for computing convex hulls in n dimensions."
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2015-src-7.2.0.tgz"
  sha256 "78b010925c3b577adc3d58278787d7df08f7c8fb02c3490e375eab91bb58a436"

  bottle do
    cellar :any
    sha256 "b90892309114ec2ec862842e46a7b8e81f023121010d00b9366b8aa07ebf065d" => :el_capitan
    sha256 "4b27e6cfb5bc6eeab81b2dbf52ecf24bbead164e8072635edd5ce53666b7ed46" => :yosemite
    sha256 "0cf09cd18d6d6f1c3d0f81fa91ccd4c5660c43e9c0364d517c173ec64e573202" => :mavericks
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

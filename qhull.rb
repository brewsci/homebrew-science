class Qhull < Formula
  desc "Qhull is a code for computing convex hulls in n dimensions."
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2015-src-7.2.0.tgz"
  sha256 "78b010925c3b577adc3d58278787d7df08f7c8fb02c3490e375eab91bb58a436"

  bottle do
    cellar :any
    revision 1
    sha256 "1e747fca91a9bb0528fac7694d03f7856fa826aaf8350818bc58a279f2e35e15" => :yosemite
    sha256 "69ab2f5f21a086464f7aa70f83314b8dd08fa24abd08761f3df446ae0bd988e3" => :mavericks
    sha256 "76b8b8a669bd1d5029083deb47df9e7601861cf193893c61637a98bce98876ec" => :mountain_lion
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

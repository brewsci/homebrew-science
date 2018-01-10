class Gfan < Formula
  desc "Computes Gröbner fans and tropical varieties"
  homepage "http://home.imf.au.dk/jensen/software/gfan/gfan.html"
  url "http://home.math.au.dk/jensen/software/gfan/gfan0.6.2.tar.gz"
  sha256 "a674d5e5dc43634397de0d55dd5da3c32bd358d05f72b73a50e62c1a1686f10a"

  bottle do
    cellar :any
    sha256 "be11d360134ecbf893d590ba31d1525397892f092f2c5883b757754aaee4dd9b" => :high_sierra
    sha256 "1c8a1963c69ef59c55c8a4fed60a9ef688e0d4a1913910aa4991f99661538e7d" => :sierra
    sha256 "04656be51b3d1b7ec247a21beb53863f6664da4e7974a282eff67b9339e332aa" => :el_capitan
    sha256 "d02f50bccabbca1c694e692331908e459c9f732f83f2fd1bf43fbac131e4e997" => :x86_64_linux
  end

  depends_on "cddlib"
  depends_on "gmp"

  fails_with :clang

  def install
    system "make", "cddnoprefix=1"
    system "make", "cddnoprefix=1","PREFIX=#{prefix}", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "examples", "homepage", "testsuite"
  end

  test do
    system "#{bin}/gfan", "--help"
  end
end

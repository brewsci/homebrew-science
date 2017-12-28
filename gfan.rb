class Gfan < Formula
  desc "Computes Gröbner fans and tropical varieties"
  homepage "http://home.imf.au.dk/jensen/software/gfan/gfan.html"
  url "http://home.math.au.dk/jensen/software/gfan/gfan0.6.2.tar.gz"
  sha256 "a674d5e5dc43634397de0d55dd5da3c32bd358d05f72b73a50e62c1a1686f10a"

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

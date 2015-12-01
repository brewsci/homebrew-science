class Gfan < Formula
  homepage "http://home.imf.au.dk/jensen/software/gfan/gfan.html"
  url "http://home.imf.au.dk/jensen/software/gfan/gfan0.5.tar.gz"
  sha256 "aaeabcf03aad9e426f1ace1f633ffa3200349600314063a7717c20a3e24db329"

  depends_on "gmp"
  depends_on "cddlib"

  def install
    system "make"
    system "make PREFIX=#{prefix} install"
    doc.install Dir["doc/*"]
    pkgshare.install "examples", "homepage", "testsuite"
  end

  test do
    system "gfan --help"
  end
end

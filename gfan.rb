require 'formula'

class Gfan < Formula
  homepage 'http://home.imf.au.dk/jensen/software/gfan/gfan.html'
  url 'http://home.imf.au.dk/jensen/software/gfan/gfan0.5.tar.gz'
  sha1 'ba4f3e4fac6bcafdfdd2244329d925e958d9ee63'

  depends_on 'gmp'
  depends_on 'cddlib'

  def install
    system "make"
    system "make PREFIX=#{prefix} install"
    doc.install Dir['doc/*']
    share.install Dir['examples', 'homepage', 'testsuite']
  end

  test do
    system "gfan --help"
  end
end

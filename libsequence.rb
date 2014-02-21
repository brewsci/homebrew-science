require 'formula'

class Libsequence < Formula
  homepage 'http://molpopgen.org/software/libsequence.html'
  url 'http://molpopgen.org/software/libsequence/libsequence-1.8.0.tar.gz'
  sha1 'c69b59226878b6eea399f67bab7ff2700eab26f5'
  head 'https://github.com/molpopgen/libsequence.git'

  depends_on 'boost' => :build
  depends_on 'gsl'

  def install
    system "./configure", "--enable-shared=no", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

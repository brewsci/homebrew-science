require 'formula'

class Libsequence < Formula
  homepage 'http://molpopgen.org/software/libsequence.html'
  url 'https://github.com/molpopgen/libsequence/archive/1.8.2.tar.gz'
  sha1 '11cce742140146f9a3fc97287a6af9e11358563e'
  head 'https://github.com/molpopgen/libsequence.git'

  depends_on 'boost' => :build
  depends_on 'gsl'

  def install
    system "./configure", "--enable-shared=no", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

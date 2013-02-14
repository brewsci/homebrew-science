require 'formula'

class Libsequence < Formula
  homepage 'http://molpopgen.org/software/libsequence.html'
  url 'http://molpopgen.org/software/libsequence/libsequence-1.7.6.tar.gz'
  sha1 '19c96a60767a317d1f4ac76cebb32cd07bd23f01'

  depends_on 'boost' => :build

  def install
    system "./configure", "--enable-shared=no", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

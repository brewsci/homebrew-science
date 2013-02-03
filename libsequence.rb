require 'formula'

class Libsequence < Formula
  homepage 'http://molpopgen.org/software/libsequence.html'
  url 'http://molpopgen.org/software/libsequence/libsequence-1.7.5.tar.gz'
  sha1 '29606adb46dc5564b24d8785620c2c24ac712c11'

  depends_on 'boost'

  fails_with :clang do
    build 425
    cause "Inconsistent exception declarations"
  end

  def install
    system "./configure", "--enable-shared=no", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

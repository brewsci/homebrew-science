require 'formula'

class Mafft < Formula
  homepage 'http://mafft.cbrc.jp/alignment/software/index.html'
  url 'http://mafft.cbrc.jp/alignment/software/mafft-7.037-with-extensions-src.tgz'
  sha1 '9bfbd95873be90761e474c807de0527168a71b18'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Clang does not allow default arguments in out-of-line definitions of
      class template members.
      EOS
  end

  def install
    cd 'core' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "PREFIX=#{prefix}",
                     "MANDIR=#{man1}",
                     "install"
    end

    cd 'extensions' do
      system "make", "CC=#{ENV.cc}",
                     "CXX=#{ENV.cxx}",
                     "CXXFLAGS=#{ENV.cxxflags}",
                     "CFLAGS=#{ENV.cflags}",
                     "PREFIX=#{prefix}",
                     "MANDIR=#{man1}",
                     "install"
    end
  end

  def test
    system 'mafft --version 2>&1 |grep -q mafft'
  end
end

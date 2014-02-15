require 'formula'

class Mafft < Formula
  homepage 'http://mafft.cbrc.jp/alignment/software/index.html'
  url 'http://mafft.cbrc.jp/alignment/software/mafft-7.130-with-extensions-src.tgz'
  sha1 'a4456895f6ddc4245d86f5dcaa7e6f35e6032d8e'

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

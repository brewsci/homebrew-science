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
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} CFAGS=#{ENV.cflags}
                   CXXFLAGS=#{ENV.cxxflags} PREFIX=#{prefix} MANDIR=#{man1}]
    make_args << "ENABLE_MULTITHREAD=" if MacOS.version <= :snow_leopard
    cd 'core' do
      system "make", *make_args
    end

    cd 'extensions' do
      system "make", *make_args
    end
  end

  def caveats
    if MacOS.version <= :snow_leopard
        <<-EOS.undent
        This build of MAFFT is not multithreaded on Snow Leopard
        because its compiler does not support thread-local storage.
        EOS
    end
  end

  def test
    system 'mafft --version 2>&1 |grep -q mafft'
  end
end

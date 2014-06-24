require 'formula'

class Mafft < Formula
  homepage 'http://mafft.cbrc.jp/alignment/software/index.html'
  url 'http://mafft.cbrc.jp/alignment/software/mafft-7.157-with-extensions-src.tgz'
  sha1 '55cd5f1d6ef43cfe01c82770836c72ad32c221c4'

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
    make_args << "install"
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

  test do
    (testpath/'test.fa').write(">1\nA\n>2\nA")
    system 'mafft test.fa'
  end
end

class Mafft < Formula
  homepage "http://mafft.cbrc.jp/alignment/software/index.html"
  #doi "10.1093/nar/gkf436"
  #tag "bioinformatics"

  url "http://mafft.cbrc.jp/alignment/software/mafft-7.157-with-extensions-src.tgz"
  sha1 "55cd5f1d6ef43cfe01c82770836c72ad32c221c4"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "be691dfc79b09186f86d410f8645bc3fee7bb228" => :yosemite
    sha1 "5f0bcbba00290ad43b0d4afa8654efaa0ce5c9d9" => :mavericks
    sha1 "cb5351b097fae326bfdc07643e45d02b3f72889d" => :mountain_lion
  end

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
    cd "core" do
      system "make", *make_args
    end

    cd "extensions" do
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
    (testpath/"test.fa").write(">1\nA\n>2\nA")
    system "mafft", "test.fa"
  end
end

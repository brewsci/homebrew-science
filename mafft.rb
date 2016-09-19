class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "http://mafft.cbrc.jp/alignment/software/index.html"
  # doi "10.1093/nar/gkf436"
  # tag "bioinformatics"

  url "http://mafft.cbrc.jp/alignment/software/mafft-7.305-with-extensions-src.tgz"
  sha256 "26fccbd7091edfe6528a0535d33738546ee57b4a3b6e43332ffc3323e29ff4d1"

  bottle do
    sha256 "ca251da2e73a13e9598ab25eb528c4305ceb14af0652c90ebb76074990c4e2ec" => :yosemite
    sha256 "ce06f63d9cd72f5b0faec1cf517d857151a5e061e25a32e6f1a21fb67153c60e" => :mavericks
    sha256 "5c9b9ab39a0e54e180a2fc3e365280e529b4c931a069661232cc4a4dceb0782c" => :mountain_lion
    sha256 "f52c02af67cdbfce002e658f485ab5af0ae44b6a744b4f5d2f800008548ba5cc" => :x86_64_linux
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
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    system "mafft", "test.fa"
  end
end

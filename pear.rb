class Pear < Formula
  homepage "http://www.exelixis-lab.org/pear"
  # doi "10.1093/bioinformatics/btt593"
  # tag "bioinformatics"

  url "http://sco.h-its.org/exelixis/web/software/pear/files/pear-0.9.6-src.tar.gz"
  sha256 "f7728371e26a5b46fa928b0f7ae1b552ed6a78815b117ba48ef1af98e96c8e2b"

  bottle do
    cellar :any
    sha256 "a41b6229ea725bf74c1c6cf2383f55d21b91cd98197f441ca9c7ec6f0fa1416f" => :yosemite
    sha256 "d23c4c17880e9eef24ce46c2ab55662e59ec0bf69da43be96fd19158c7001efc" => :mavericks
    sha256 "426c5620df6007bfe8ea65181ebcfecf4b0f63cb657e346296af21a994e88d7e" => :mountain_lion
    sha256 "377d1990fe1f56ad5dcb2ea9c4729d9140fbb18ff46590874b1685ce005a4c62" => :x86_64_linux
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pear --help 2>&1 |grep -q pear"
  end
end

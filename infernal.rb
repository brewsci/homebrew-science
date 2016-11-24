class Infernal < Formula
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  # doi "10.1093/bioinformatics/btp157"
  # tag "bioinformatics"

  url "http://eddylab.org/software/infernal/infernal-1.1.2.tar.gz"
  sha256 "ac8c24f484205cfb7124c38d6dc638a28f2b9035b9433efec5dc753c7e84226b"

  bottle do
    cellar :any
    sha256 "b0ae6239bf56e3f11ccdb8c1534c733adfbf1708b4e7ab563664caacab5e492a" => :yosemite
    sha256 "1795cdba9ce8f61ad3b46f748015e9a9a2a124be9e681dcef407f3fd310c0a09" => :mavericks
    sha256 "d132b98769966008d8c320a6d80d50636b95b3f4d6d05bd51986f22e2f5f0e94" => :mountain_lion
    sha256 "55b4128aeb4c49f274e1d969a41e6e44d16861a1d9ca9116ee87c26ae809fa13" => :x86_64_linux
  end

  deprecated_option "check" => "with-test"
  deprecated_option "with-check" => "with-test"

  option "with-test", "Run the test suite (`make check`). Takes a couple of minutes."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/cmsearch", "-h"
  end
end

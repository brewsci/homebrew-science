class Infernal < Formula
  homepage "http://infernal.janelia.org/"
  #doi "10.1093/bioinformatics/btp157"
  #tag "bioinformatics"

  url "http://selab.janelia.org/software/infernal/infernal-1.1.1.tar.gz"
  sha1 "b83fbc3a50c49ad51e40b37195aeacec94897d30"

  bottle do
    cellar :any
    sha256 "b0ae6239bf56e3f11ccdb8c1534c733adfbf1708b4e7ab563664caacab5e492a" => :yosemite
    sha256 "1795cdba9ce8f61ad3b46f748015e9a9a2a124be9e681dcef407f3fd310c0a09" => :mavericks
    sha256 "d132b98769966008d8c320a6d80d50636b95b3f4d6d05bd51986f22e2f5f0e94" => :mountain_lion
  end

  deprecated_option "check" => "with-check"

  option "with-check", "Run the test suite (`make check`). Takes a couple of minutes."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "cmsearch", "-h"
  end
end

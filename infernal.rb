class Infernal < Formula
  homepage "http://infernal.janelia.org/"
  #doi "10.1093/bioinformatics/btp157"
  #tag "bioinformatics"

  url "http://selab.janelia.org/software/infernal/infernal-1.1.1.tar.gz"
  sha1 "b83fbc3a50c49ad51e40b37195aeacec94897d30"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "1babacebaf18df5698ca52eb54313a5b03aa2475" => :yosemite
    sha1 "b10867d6dcf06bf4bc86edd42220652ca5d64272" => :mavericks
    sha1 "74847dd59196b2b68a6afb79f956675a5e29562c" => :mountain_lion
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

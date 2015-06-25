class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "http://ftpmirror.gnu.org/datamash/datamash-1.0.7.tar.gz"
  sha256 "1a0b300611a5dff89e08e20773252b00f5e2c2d65b2ad789872fc7df94fa8978"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "507abcb8fc1ddd8f3d15347355e9ca0069c34e4eedc40dcafda5f10c930c3278" => :yosemite
    sha256 "f6beb68ca96513fb83bbce4d20f8303ee9cccde90b83f2ede375d7aee240940d" => :mavericks
    sha256 "ddc8d16975d24b36a6853c011436feafb99822254829cad79cc5ca00a17771cd" => :mountain_lion
  end

  head do
    url "git://git.savannah.gnu.org/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_equal "55\n", shell_output("seq 10 |'#{bin}/datamash' sum 1")
  end
end

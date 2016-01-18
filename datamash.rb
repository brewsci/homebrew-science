class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "http://ftpmirror.gnu.org/datamash/datamash-1.1.0.tar.gz"
  sha256 "a9e5acc86af4dd64c7ac7f6554718b40271aa67f7ff6e9819bdd919a25904bb0"

  bottle do
    cellar :any
    sha256 "31f58c1a0413c3caded21dc1f8dc990ea5902c556bc07c968ce1ce1c6c6effcd" => :yosemite
    sha256 "35ec93c7848276b993f558f18ebad3c278eb14936913a33c07777b2652f9e7ec" => :mavericks
    sha256 "89170423888b0250b2d53c18b128440dda6e18bdf21a49603426d2cb0fc8867e" => :mountain_lion
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

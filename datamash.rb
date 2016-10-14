class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "http://ftpmirror.gnu.org/datamash/datamash-1.1.0.tar.gz"
  sha256 "a9e5acc86af4dd64c7ac7f6554718b40271aa67f7ff6e9819bdd919a25904bb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f822b6691ac95a86f46a0fcc4c0d283d69b6915cbef26b580df5ef5850642670" => :el_capitan
    sha256 "13ab517271aa7c33e37b70f69121f76d59a5a40cf1e4696d590ef7fd4924869d" => :yosemite
    sha256 "d019e9ca0090d450f98fdc5c4c1c0a114543392dceb155b15620ba903757662e" => :mavericks
    sha256 "dddd2d241850472545900c869e081c31b7d8a8d6a7e9095035bc4e0f91bc852b" => :x86_64_linux
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

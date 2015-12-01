class Sally < Formula
  homepage "http://www.mlsec.org/sally"
  url "http://www.mlsec.org/sally/files/sally-1.0.0.tar.gz"
  sha256 "da706cb818fc2a3fc8f4a624d41010801ee8f96f0573b83be0c5fde886099148"

  bottle do
    cellar :any
    sha256 "714d4d1cd6797ae20e3590de75a5761a211d0488fc9166044bd52b3cc8c502be" => :yosemite
    sha256 "73de142db9176ebde43ab21c5ce077c8059ccf687cc0a0c205cb0682cc9eb3d7" => :mavericks
    sha256 "0f6de508ffda1d8c2fb6faee646b290d8b0240dcfd6bf5affe3e1462fcc762b7" => :mountain_lion
  end

  head do
    url "https://github.com/rieck/sally.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libconfig"
  depends_on "libarchive" => :recommended

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/sally", "--version"
  end
end

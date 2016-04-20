class Harry < Formula
  desc "A Tool for Measuring String Similarity"
  homepage "http://www.mlsec.org/harry"
  url "http://www.mlsec.org/harry/files/harry-0.4.2.tar.gz"
  sha256 "43315f616057cc1640dd87fc3d81453b97ce111683514ad99909d0033bcb578a"

  bottle do
    sha256 "37072d961f3c6e9dcdd206457501372b8423ce23d9fb1b40a48cf7123631c7f5" => :el_capitan
    sha256 "ceca346556b3618874bb46713d72a0cb6ce546d0d1429fd30788d742c39883ad" => :yosemite
    sha256 "fd67734b1d24a09f23c427c045abd2422ff374fe59b60a9611bba8ca8b129d63" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libconfig"
  depends_on "libarchive" => :recommended

  head do
    url "https://github.com/rieck/harry.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    opoo "Clang does not support OpenMP. Compile with gcc to use multi-threading." if ENV.compiler == :clang
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/harry", "--version"
  end
end

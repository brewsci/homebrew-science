class Harry < Formula
  homepage "http://www.mlsec.org/harry"
  url "http://www.mlsec.org/harry/files/harry-0.4.1.tar.gz"
  sha256 "7e4d0cd7c7b4d91cc54fcf313862b5d8fc04cda115f5d3b36ee4a96918724cda"

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

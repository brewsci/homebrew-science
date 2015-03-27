require "formula"

class Harry < Formula
  homepage "http://www.mlsec.org/harry"
  url "http://www.mlsec.org/harry/files/harry-0.4.0.tar.gz"
  sha256 "cb3526efbf119cae1de0c65745a40788fb1c483f95dab568ce75e5e222abff78"

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

require "formula"

class Libpll < Formula
  homepage "http://www.libpll.org/"
  url "http://www.libpll.org/Downloads/libpll-1.0.0.tar.gz"
  sha1 "023e0e704c57c463c34f85b31d597391972af810"
  head "https://git.assembla.com/phylogenetic-likelihood-library.git"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  option "without-check", "Disable build-time checking (not recommended)"

  # Don't include malloc.h (linux requirement)
  stable do
    patch do
      url "https://gist.githubusercontent.com/kgori/2e0d4075207fdbeebe7b/raw/217db2debf9e8eccca55e363f243b8f710bee6b6/mem_alloc_patch"
      sha1 "8885119361e6b7bcccefb0840cd2a6c3263419ba"
    end
  end

  # Get automake to work properly over subdirectories
  patch :DATA

  def install
    system "glibtoolize"
    system "autoheader"
    system "aclocal", "-I", "m4"
    system "automake", "--add-missing"
    system "autoreconf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    cd "src" do
      system "make"
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end
end

__END__

diff --git a/configure.ac b/configure.ac
index bb9f535..fba1f9c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@
 AC_PREREQ([2.68])
 AC_INIT([libpll], [1.0.0], [Tomas.Flouri@h-its.org])
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([subdir-objects])


 # AM_MAINTAINER_MODE


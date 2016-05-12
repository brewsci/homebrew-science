class Glpk448 < Formula
  desc "Library for Linear Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "http://ftpmirror.gnu.org/glpk/glpk-4.48.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.48.tar.gz"
  sha256 "abc2c8f895b20a91cdfcfc04367a0bc8677daf8b4ec3f3e86c5b71c79ac6adb1"
  revision 1

  bottle do
    cellar :any
    sha256 "a778e6900d40062d8681d19e31308ad59dff480b74c6e6bba4e646dd8a07a5b8" => :el_capitan
    sha256 "c19068caffac7c64aa807965e5568521cb38ab81236dd6c39293a47d5d409472" => :yosemite
    sha256 "3b636818a037ba1f089fcf5162af9787f4036aeafc2b91d2eb9bd0847c734f4e" => :mavericks
  end

  keg_only "This formula installs an older version of the GLPK libraries"

  depends_on "gmp" => :recommended

  patch DATA

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-gmp" if build.with? "gmp"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
    include.install "src/amd/amd.h"
    include.install "src/colamd/colamd.h"
  end

  test do
    (testpath/"test.c").write <<-EOF.undent
    #include "stdio.h"
    #include "glpk.h"

    int main(int argc, const char *argv[])
    {
        printf("%s", glp_version());
        return 0;
    }
    EOF
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lglpk", "-o", "test"
    assert_equal `./test`, version.to_s
  end
end

__END__
diff --git a/src/Makefile.am b/src/Makefile.am
index cec1f74..9e20042 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -4,8 +4,7 @@ include_HEADERS = glpk.h

 lib_LTLIBRARIES = libglpk.la

-libglpk_la_LDFLAGS = -version-info 33:0:0 \
--export-symbols-regex '^(glp_|_glp_lpx_).*'
+libglpk_la_LDFLAGS = -version-info 33:0:0

 libglpk_la_SOURCES = \
 glpapi01.c \
diff --git a/src/Makefile.in b/src/Makefile.in
index 6e61555..4d112dc 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -264,8 +264,7 @@ top_builddir = @top_builddir@
 top_srcdir = @top_srcdir@
 include_HEADERS = glpk.h
 lib_LTLIBRARIES = libglpk.la
-libglpk_la_LDFLAGS = -version-info 33:0:0 \
--export-symbols-regex '^(glp_|_glp_lpx_).*'
+libglpk_la_LDFLAGS = -version-info 33:0:0

 libglpk_la_SOURCES = \
 glpapi01.c \

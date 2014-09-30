require "formula"

class Pspp < Formula
  homepage "http://www.gnu.org/software/pspp/"
  url "http://ftpmirror.gnu.org/pspp/pspp-0.8.4.tar.gz"
  mirror "http://ftp.gnu.org/gnu/pspp/pspp-0.8.4.tar.gz"
  sha1 "75c2ee0e1b87e9d653fb9cf2dd95da8d9b5d1caf"

  option "without-check", "Skip running the PSPP test suite"
  option "without-gui", "Build without gui support"

  depends_on "pkg-config" => :build

  depends_on :x11
  depends_on "gsl"
  depends_on "glib"
  depends_on "gettext"
  depends_on "readline"
  depends_on "libxml2"
  depends_on "cairo"
  depends_on "pango"

  depends_on "postgresql" => :optional

  if build.with? "gui"
    depends_on "gtk+"
    depends_on "gtksourceview"
    depends_on "freetype"
    depends_on "fontconfig"
  end

  patch :DATA

  def install
    args = ["--disable-rpath"]
    args << "--without-libpq" if build.without? "postgresql"
    args << "--without-gui" if build.without? "gui"

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pspp", "--version"
  end
end

__END__
diff --git a/tests/language/stats/frequencies.at b/tests/language/stats/frequencies.at
index d321e57..90d54f5 100644
--- a/tests/language/stats/frequencies.at
+++ b/tests/language/stats/frequencies.at
@@ -180,7 +180,7 @@ frequencies /x
 ])
 # Cannot use the CSV driver for this because it does not output charts
 # at all.
-AT_CHECK([pspp -O format=pdf frequencies.sps], [0], [ignore])
+AT_CHECK([pspp -O format=pdf frequencies.sps], [0], [ignore], [ignore])
 AT_CLEANUP
 
 # Tests for a bug which crashed PSPP when the median and a histogram
diff --git a/tests/language/data-io/get-data-psql.at b/tests/language/data-io/get-data-psql.at
index 692de09..ea9b222 100644
--- a/tests/language/data-io/get-data-psql.at
+++ b/tests/language/data-io/get-data-psql.at
@@ -12,7 +12,7 @@ m4_define([INIT_PSQL],
    PGHOST="$socket_dir"
    export PGHOST
    AT_CHECK([initdb -A trust], [0], [ignore])
-   AT_CHECK([pg_ctl start -w -o "-k $socket_dir -h ''"], [0], [ignore])
+   AT_CHECK([pg_ctl start -w -o "-k $socket_dir -h 'example.com'"], [0], [ignore])
    trap 'CLEANUP_PSQL' 0
    AT_CHECK([createdb -h "$socket_dir" -p $PG_PORT $PG_DBASE],
       [0], [ignore], [ignore])

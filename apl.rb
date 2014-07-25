require "formula"

class Apl < Formula
  homepage "http://www.gnu.org/software/apl"
  url "http://gnu.mirror.constant.com/apl/apl-1.3.tar.gz"
  mirror "http://mirror.csclub.uwaterloo.ca/gnu/apl/apl-1.3.tar.gz"
  sha1 "f4cd44a716dc5c5af1cd88811e10efa03d327fd2"

  depends_on "readline"
  depends_on "gettext" => :optional     # For internationalized version.
  depends_on :x11      => :recommended  # For xmodmap.

  # See http://lists.gnu.org/archive/html/bug-apl/2014-04/msg00009.html
  patch :DATA

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    configure_args = ["--disable-debug",
                      "--disable-dependency-tracking",
                      "--disable-silent-rules",
                      "--prefix=#{prefix}"]
    configure_args << "--disable-nls" if build.without? "gettext"
    apl_options = ["ASSERT_LEVEL_WANTED=1",
                   "DYNAMIC_LOG_WANTED=yes",
                   "MAX_RANK_WANTED=8",
                   "PRINT_SEMA_WANTED=yes",
                   "VALUE_CHECK_WANTED=no",
                   "VALUE_HISTORY_WANTED=no",
                   "VF_TRACING_WANTED=no",
                   "SHORT_VALUE_LENGTH_WANTED=42",
                   "GPROF_WANTED=no"]
    system "./configure", *(apl_options + configure_args)
    system "make", "install"
    (share / "apl/support-files").install Dir["support-files/*"]
  end

  test do
    (testpath / "test.apl").write <<-EOS.undent
      N ← 4 5 6 7
      N+4
      +/N
      )OFF
    EOS
    system bin/"apl", "-f", testpath/"test.apl"
  end

  def caveats
    s = ""
    s += <<-EOS.undent
      See
        #{share}/doc/apl/APL-on-Macintosh.pdf
      for information on installing APL fonts.
      EOS

    if build.with? :x11
      s += <<-EOS.undent
        Your keyboard may be re-mapped for APL using
          xmodmap support-files/apl.xmodmap
        EOS
    end
    return s
  end
end

__END__
diff --git a/src/IntCell.cc b/src/IntCell.cc
index 2b64334..49240ff 100644
--- a/src/IntCell.cc
+++ b/src/IntCell.cc
@@ -350,7 +350,7 @@ const int64_t a = A->get_int_value();
    if (b == 0)   { new (Z) IntCell(1);   return; }   // N^0 = 1
    if (b == 1)   { new (Z) IntCell(a);   return; }   // N^1 = N
 
-const double power = pow(a, b);
+const double power = pow((double)a, (double)b);
    if (power > LARGE_INT || b < 0)
       {
         new (Z) FloatCell(power);


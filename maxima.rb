class Maxima < Formula
  desc "Computer algebra system"
  homepage "http://maxima.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.37.2-source/maxima-5.37.2.tar.gz"
  sha256 "b6bc38264405f092817f863d3a09e25027c0d3eb6c61e00db8c232ea2a41aa6b"

  bottle do
    sha256 "d88c8f10575c5fe31b5d817b664931ada2a8f5f9abe2c6027328aece3b0c17e0" => :el_capitan
    sha256 "b66a746086efe814c3e9ef5603ab9773e6853865845076fde980ab9adaef729c" => :yosemite
    sha256 "56463b0c077788ebc0f2e11686cce88f68760d419840689ef8e960a50973c1c0" => :mavericks
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  # required for maxima help(), describe(), "?" and "??" lisp functionality
  skip_clean "share/info"

  # fixes 3468021: imaxima.el uses incorrect tmp directory on OS X:
  # https://sourceforge.net/tracker/?func=detail&aid=3468021&group_id=4933&atid=104933
  patch :DATA

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sbcl", "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl",
                          "--enable-sbcl-exec",
                          "--enable-gettext"
    # Per build instructions
    ENV["LANG"] = "C"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end

__END__
diff --git a/interfaces/emacs/imaxima/imaxima.el b/interfaces/emacs/imaxima/imaxima.el
index e3feaa6..3a52a0b 100644
--- a/interfaces/emacs/imaxima/imaxima.el
+++ b/interfaces/emacs/imaxima/imaxima.el
@@ -296,6 +296,8 @@ nil means no scaling at all, t allows any scaling."
 	 (temp-directory))
 	((eql system-type 'cygwin)
 	 "/tmp/")
+	((eql system-type 'darwin)
+	 "/tmp/")
 	(t temporary-file-directory))
   "*Directory used for temporary TeX and image files."
   :type '(directory)

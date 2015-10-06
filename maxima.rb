class Maxima < Formula
  desc "Computer algebra system"
  homepage "http://maxima.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.37.2-source/maxima-5.37.2.tar.gz"
  sha256 "b6bc38264405f092817f863d3a09e25027c0d3eb6c61e00db8c232ea2a41aa6b"

  bottle do
    sha256 "b4de12a5030ca617f54b3b521594bf41d9189f5ad2f9a2a59b92da65b89753ed" => :yosemite
    sha256 "cac81a7194531c4c71d31e2a7e2d8f58079cf33789c468ffeacda93652f975be" => :mavericks
    sha256 "dc3300cce67db65b6c2f4204e2841b72d8106b5a931ccdf92c56b06029a78a5f" => :mountain_lion
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

class Maxima < Formula
  homepage "http://maxima.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.34.1-source/maxima-5.34.1.tar.gz"
  sha1 "3f33730ca374c282a543da5ed78572eff72da34f"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "6371b41bfe585f224acab6f4852f5808fa72600b" => :yosemite
    sha1 "3c1f1c41ec5127e8f6f6e2ab6b0aaa368b1ea142" => :mavericks
    sha1 "ea44137b93530cb8dab8085facf18e0445428498" => :mountain_lion
  end

  depends_on "gettext"
  depends_on "sbcl"
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

require 'formula'

class Maxima < Formula
  homepage 'http://maxima.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/maxima/Maxima-source/5.31.3-source/maxima-5.31.3.tar.gz'
  sha1 'e45500f91ecc96fb9f1fe4a503e2d3d024b8f689'

  depends_on 'gettext'
  depends_on 'sbcl'
  depends_on 'gnuplot'
  depends_on 'rlwrap'

  # required for maxima help(), describe(), "?" and "??" lisp functionality
  skip_clean 'share/info'

  def patches
    # fixes 3468021: imaxima.el uses incorrect tmp directory on OS X:
    # https://sourceforge.net/tracker/?func=detail&aid=3468021&group_id=4933&atid=104933
    DATA
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sbcl",
                          "--enable-gettext"
    # Per build instructions
    ENV['LANG'] = 'C'
    system 'make'
    system 'make check'
    system 'make install'
  end

  def test
    system "#{bin}/maxima", "--batch-string='run_testsuite(); quit();'"
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

class Pymol < Formula
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.7/pymol-v1.7.6.0.tar.bz2"
  sha256 "cf142732b5206ea65ebcc0cc162f9d3c88ecacc701ac41d1a5e9b38972700395"
  head "https://svn.code.sf.net/p/pymol/code/trunk/pymol"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "f9508e972a15a881b346222545ad9a63f1ba838066fe72ca57ddf366965c80fa" => :yosemite
    sha256 "e9813a889011afcdfd61ecaf5b581e5408461b6d14028e646406bf706270d7ae" => :mavericks
    sha256 "d0348d18fdbb87c697ef2d68ab6849421bef34406181048b2011cb0bad1787b8" => :mountain_lion
  end

  depends_on "glew"
  depends_on "python" => "with-tcl-tk"
  depends_on "homebrew/dupes/tcl-tk" => ["with-threads", "with-x11"]
  depends_on :x11

  # Fix outdated X11 path: https://sourceforge.net/p/pymol/patches/10/
  patch :DATA

  def install
    ENV.append_to_cflags "-Qunused-arguments" if MacOS.version < :mavericks

    system "python", "-s", "setup.py", "install",
                     "--bundled-pmw",
                     "--install-scripts=#{libexec}/bin",
                     "--install-lib=#{libexec}/lib/python2.7/site-packages"

    bin.install libexec/"bin/pymol"
  end

  test do
    system bin/"pymol", libexec/"lib/python2.7/site-packages/pymol/pymol_path/data/demo/pept.pdb"
  end

  def caveats; <<-EOS.undent
    On some Macs, the graphics drivers do not properly support stereo
    graphics. This will cause visual glitches and shaking that stay
    visible until X11 is completely closed. This may even require
    restarting your computer. Launch explicitly in Mono mode using:
      pymol -M
    EOS
  end
end
__END__
diff --git a/modules/pymol/__init__.py b/modules/pymol/__init__.py
index 792d273..3d335fd 100644
--- a/modules/pymol/__init__.py
+++ b/modules/pymol/__init__.py
@@ -391,7 +391,7 @@ def prime_pymol():

     # legacy X11 launching on OSX
     if sys.platform == 'darwin' and invocation.options.external_gui == 1:
-        xdpyinfo = "/usr/X11R6/bin/xdpyinfo"
+        xdpyinfo = "/opt/X11/bin/xdpyinfo"
         if not os.path.exists(xdpyinfo) or \
                 os.system(xdpyinfo + " >/dev/null 2>&1"):
             # launch X11 (if needed)

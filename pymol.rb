class Pymol < Formula
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.7/pymol-v1.7.6.0.tar.bz2"
  sha256 "cf142732b5206ea65ebcc0cc162f9d3c88ecacc701ac41d1a5e9b38972700395"
  head "https://svn.code.sf.net/p/pymol/code/trunk/pymol"
  revision 1

  bottle do
    cellar :any
    sha256 "9c1ae684e673d636446970481a31fa05bd96825a1d664e27a4d6d98db34cde2c" => :el_capitan
    sha256 "cd014118fe4d736310b39b74eaa2fda608f979349d3ff00f74f4257ddbf941c9" => :yosemite
    sha256 "bdc51e81a52e459f362e2a587f9ae404b09a60f8a52dc1dcf46716a2801c7545" => :mavericks
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

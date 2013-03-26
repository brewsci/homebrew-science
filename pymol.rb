require 'formula'

class Pymol < Formula
  homepage 'http://pymol.org'
  url 'http://sourceforge.net/projects/pymol/files/pymol/1.5.0.1/pymol-v1.5.0.1.tar.bz2'
  sha1 'b59ff50437d34f21ca8ffd007a600de4df684073'
  head 'https://pymol.svn.sourceforge.net/svnroot/pymol/trunk/pymol'

  depends_on "glew"
  depends_on 'Pmw'
  depends_on 'python' => 'with-brewed-tk'
  depends_on 'homebrew/dupes/tcl-tk' => ['enable-threads','with-x11']
  depends_on :freetype
  depends_on :libpng
  depends_on :x11

  # To use external GUI tk must be built with --enable-threads
  # and python must be setup to use that version of tk with --with-brewed-tk
  depends_on 'Tkinter' => :python

  option 'default-stereo', 'Set stereo graphics as default'

  def install
    # PyMol uses ./ext as a backup to look for ./ext/include and ./ext/lib
    ln_s HOMEBREW_PREFIX, "./ext"

    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages
    ENV['PYTHONPATH'] = temp_site_packages

    args = [
      "--verbose",
      "install",
      "--install-scripts=#{bin}",
      "--install-lib=#{temp_site_packages}",
    ]

    # build the pymol libraries
    system "python", "-s", "setup.py", *args
    system "python", "-s", "setup2.py", "install" unless build.head?

    # get the executable
    bin.install("pymol")
  end

  def patches
    p = []
    # Head works already, but 1.5.0.1 needs to be patched, so I just took
    # the part of the setup.py from head and applied it here:
    p << DATA unless build.head?
    # This patch adds checks that force mono as default
    p << 'https://gist.github.com/raw/1b84b2ad3503395f1041/2a85dc56b4bd1ea28d99ce0b94acbf7ac880deff/pymol_disable_stereo.diff' unless build.include? 'default-stereo'
    # This patch disables the vmd plugin. VMD is not something we can depend on for now. The plugin is set to always install as of revision 4019.
    p << 'https://gist.github.com/scicalculator/4966279/raw/9eb79bf5b6a36bd8f684bae46be2fcf834fea8de/pymol_disable_vmd_plugin.diff' if build.head?
    p
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    # commandline test
    system "pymol","-c"
    if build.include? "gui"
        # serious bench test
        system "pymol","-b","-d","quit"
    end
  end

  def caveats
    <<-EOS.undent

    In order to get the most out of pymol, you will want the external
    gui. This requires a thread enabled tk installation and python
    linked to it. Install these with the following commands.
      brew tap homebrew/dupes
      brew install homebrew/dupes/tcl-tk --enable-threads --with-x11
      brew install python --with-brewed-tk

    On some macs, the graphics drivers do not properly support stereo
    graphics. This will cause visual glitches and shaking that stay
    visible until x11 is completely closed. This may even require
    restarting your computer. Therefore, we install pymol in a way that
    defaults to mono graphics. This is equivalent to running pymol with
    the "-M" option. You can still run in stereo mode by running
      pymol -S

    You can install pymol such that it defaults to stereo with the
    "--default-stereo" option.

    EOS
  end

end

__END__
diff --git a/setup.py b/setup.py
index 18866a2..a18d793 100755
--- a/setup.py
+++ b/setup.py
@@ -100,16 +127,43 @@ elif sys.platform=='darwin':
         #
         # REMEMEBER to use "./ext/bin/python ..."
         #
-        EXT = os.getcwd()+"/ext"
+        # create shader text
+        try:
+            os.makedirs("generated/include")
+        except OSError:
+            # ignore error if directory already exists
+            pass
+
+        try:
+            os.makedirs("generated/src")
+        except OSError:
+            # ignore error if directory already exists
+            pass
+
+        import create_shadertext
+
+        outputheader = open("generated/include/ShaderText.h",'w')
+        outputfile = open("generated/src/ShaderText.c",'w')
+
+        create_shadertext.create_shadertext("data/shaders",
+                                            "shadertext.txt",
+                                            outputheader,
+                                            outputfile)
+
+        outputheader.close()
+        outputfile.close()
+
+        EXT = "/opt/local"
         inc_dirs=["ov/src",
                   "layer0","layer1","layer2",
-                  "layer3","layer4","layer5", 
-                  "/usr/X11R6/include",
+                  "layer3","layer4","layer5",
                   EXT+"/include",
                   EXT+"/include/GL",
                   EXT+"/include/freetype2",
-		  "modules/cealign/src",
-		  "modules/cealign/src/tnt",
+      "modules/cealign/src",
+      "modules/cealign/src/tnt",
+                  "generated/include",
+                  "generated/src",
                   ]
         libs=[]
         pyogl_libs = []
@@ -117,11 +171,19 @@ elif sys.platform=='darwin':
         def_macros=[("_PYMOL_MODULE",None),
                     ("_PYMOL_LIBPNG",None),
                     ("_PYMOL_FREETYPE",None),
+                    ("_PYMOL_INLINE",None),
+                    ("_PYMOL_NUMPY",None),
+                    ("_PYMOL_OPENGL_SHADERS",None),
+                    ("NO_MMLIBS",None),
+                    ("_PYMOL_CGO_DRAWARRAYS",None),
+                    ("_PYMOL_CGO_DRAWBUFFERS",None),
+                    ("_CGO_DRAWARRAYS",None),
+                    ("_PYMOL_GL_CALLLISTS",None),
+                    ("OPENGL_ES_2",None),
                     ]
-        ext_comp_args=[]
+        ext_comp_args=["-ffast-math","-funroll-loops","-O3","-fcommon"]
         ext_link_args=[
-            "-L/usr/X11R6/lib64", "-lGL", "-lXxf86vm",
-            "-L"+EXT+"/lib", "-lpng", "-lglut", "-lfreetype"
+                    "-L"+EXT+"/lib", "-lpng", "-lGL", "-lglut", "-lGLEW", "-lfreetype"
             ]
 #============================================================================
 else: # linux or other unix

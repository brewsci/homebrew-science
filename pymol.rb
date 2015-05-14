class Pymol < Formula
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.7/pymol-v1.7.4.0.tar.bz2"
  sha1 "8e091a0ed6a3d7389f10021a77b0d217b6c36331"
  head "https://svn.code.sf.net/p/pymol/code/trunk/pymol"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "4b3adcc1bb4f352533cf26eab50801912f9789cb" => :yosemite
    sha1 "40ec03a7b15e8514a4cd77a3d43ca7c582e84f16" => :mavericks
    sha1 "57911681119609114ee61c6b7298cabcd1c69256" => :mountain_lion
  end

  depends_on "homebrew/dupes/tcl-tk" => ["with-threads", "with-x11"]
  depends_on "glew"
  depends_on "python" => "with-tcl-tk"
  depends_on "freetype"
  depends_on "libpng"
  depends_on :x11

  resource "pmw" do
    url "https://downloads.sourceforge.net/project/pmw/Pmw/Pmw.1.3.3/Pmw.1.3.3.tar.gz"
    sha1 "0ff7f03245640da4f37a97167967de8d09e4c6a6"
  end

  # This patch disables the vmd plugin. VMD is not something we can depend on for now.
  # The plugin is set to always install as of revision 4019.
  patch :DATA

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("pmw").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # PyMol uses ./ext as a backup to look for ./ext/include and ./ext/lib
    ln_s HOMEBREW_PREFIX, "./ext"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    args = [
      "--verbose",
      "--install-scripts=#{libexec}/bin",
      "--install-lib=#{libexec}/lib/python2.7/site-packages",
    ]

    system "python", "-s", "setup.py", "install", *args
    bin.install libexec/"bin/pymol"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"pymol", libexec/"lib/python2.7/site-packages/pymol/pymol_path/data/demo/pept.pdb"
  end

  def caveats; <<-EOS.undent
    In order to get the most out of PyMOL, you will want the external
    GUI. This requires a thread enabled Tk installation and Python
    linked to it. Install these with the following commands:
      brew tap homebrew/dupes
      brew install homebrew/dupes/tcl-tk --enable-threads --with-x11
      brew install python --with-brewed-tk

    On some Macs, the graphics drivers do not properly support stereo
    graphics. This will cause visual glitches and shaking that stay
    visible until X11 is completely closed. This may even require
    restarting your computer. Launch explicitly in Mono mode using:
      pymol -M

    EOS
  end
end

__END__
diff --git a/setup.py b/setup.py
index 8fd9bc1..5684ae3 100644
--- a/setup.py
+++ b/setup.py
@@ -197,7 +197,7 @@ ext_link_args = []
 data_files = []
 ext_modules = []

-if True:
+if False:
     # VMD plugin support
     pymol_src_dirs += [
         'contrib/uiuc/plugins/include',

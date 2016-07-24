class Pymol < Formula
  desc "OpenGL based molecular visualization system"
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.8/pymol-v1.8.2.1.tar.bz2"
  sha256 "fc5d33d7e36364567462cee19b9b132530a83cbab3fafcf373f2a17f127b3f4e"
  head "https://svn.code.sf.net/p/pymol/code/trunk/pymol"

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

  def install
    ENV.append_to_cflags "-Qunused-arguments" if MacOS.version < :mavericks

    system "python", "-s", "setup.py", "install",
                     "--bundled-pmw",
                     "--install-scripts=#{libexec}/bin",
                     "--install-lib=#{libexec}/lib/python2.7/site-packages"

    bin.install libexec/"bin/pymol"
  end

  def caveats; <<-EOS.undent
    On some Macs, the graphics drivers do not properly support stereo
    graphics. This will cause visual glitches and shaking that stay
    visible until X11 is completely closed. This may even require
    restarting your computer. Launch explicitly in Mono mode using:
      pymol -M
    EOS
  end

  test do
    system bin/"pymol", libexec/"lib/python2.7/site-packages/pymol/pymol_path/data/demo/pept.pdb"
  end
end

class Pymol < Formula
  desc "OpenGL based molecular visualization system"
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.8/pymol-v1.8.2.1.tar.bz2"
  sha256 "fc5d33d7e36364567462cee19b9b132530a83cbab3fafcf373f2a17f127b3f4e"
  head "https://svn.code.sf.net/p/pymol/code/trunk/pymol"

  bottle do
    cellar :any
    sha256 "0fa0705a99781f94a1178110e8398caa2c5f47a1c3618c966cd558fe5c0e53bb" => :el_capitan
    sha256 "8fc26c4981fb1b503c22d2513d926a15ef7c33abe4a8b1d53cf546c5b7e9c3b6" => :yosemite
    sha256 "417e7c64a6a55057c3e2aa396be60e6c8b305f7ec83d2fa2ad845a4590ca4f14" => :mavericks
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

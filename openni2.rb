class Openni2 < Formula
  desc "Open source natural interaction library, version 2"
  homepage "https://structure.io/openni"
  url "https://github.com/occipital/OpenNI2/archive/v2.2.0-debian.tar.gz"
  version "2.2.0-debian"
  sha256 "08f6842f20d1098ab2ebafadaac0130ffae5abd34cdf464bb6100cbe01ed95a8"
  version_scheme 1
  head "https://github.com/occipital/OpenNI2.git"

  option "with-docs", "Build documentation using javadoc (might fail with Java 1.8)"
  option "with-samples", "Install Samples"

  depends_on :python
  depends_on :java
  depends_on "libusb"
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "linuxbrew/xorg/mesa" unless OS.mac?
  depends_on "freeglut" unless OS.mac?

  def install
    if OS.mac?
      inreplace "source/Tools/NiViewer/Draw.h", "#include <GL/gl.h>", "#include <OpenGL/gl.h>"
    end

    system "make", "all"
    system "make", "doc" if build.with? "docs"
    inreplace "Packaging/Harvest.py", "self.copyDocumentation(docDir)", "" if build.without? "docs"
    mkdir "out"
    system "python", "Packaging/Harvest.py", "out", "x64"

    cd "out"

    (lib+"ni2").install Dir["Redist/*"]
    (include+"ni2").install Dir["Include/*"]
    (pkgshare+"tools").install Dir["Tools/*"]
    (pkgshare+"samples").install Dir["Samples/*"] if build.with? "samples"
    doc.install "Documentation" if build.with? "docs"
  end

  def caveats; <<-EOS.undent
    Add the recommended variables to your dotfiles.
     * On Bash, add them to `~/.bash_profile`.
     * On Zsh, add them to `~/.zprofile` instead.

    export OPENNI2_INCLUDE=#{HOMEBREW_PREFIX}/include/ni2
    export OPENNI2_REDIST=#{HOMEBREW_PREFIX}/lib/ni2
    EOS
  end
end

class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.0.0/pcb-4.0.0.tar.gz"
  sha256 "8ede13acd0bdc1bc3c347b603718a92c5420b63f80724182ae5b25881e9adac4"
  version_scheme 1
  head "git://git.geda-project.org/pcb.git"

  bottle do
    sha256 "afffa8b991dc0d8dedeabf4d97869ef294a9a44885ffdeeaafd0da1425150d02" => :el_capitan
    sha256 "21b557b5ec551b01f8845a9166feff7e0bef94a16d93f455f3d057c60cab9d2d" => :yosemite
    sha256 "d83abec9b548ffb5268cfa39810ac902c9dd3daddf890f30459ab19f9078a976" => :mavericks
  end

  option "with-doc", "Build the documentation (requires LaTeX)."
  option "with-opengl", "Configure pcb with OpenGL, may cause garbled screen."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "dbus"
  depends_on "gtk+"
  depends_on "gd"
  depends_on "glib"
  depends_on "gtkglext"
  depends_on :tex if build.with? "doc"
  depends_on "perl" if OS.linux?

  conflicts_with "gts", :because => "both install `include/gts.h`"

  # There's a missing define from GLU. Defining this fixes everything up.
  patch :DATA

  def install
    if OS.mac? && build.with?("opengl")
      inreplace ["src/hid/common/hidgl.c", "src/hid/gtk/gtkhid-gl.c"] do |s|
        s.gsub! "#  include <GL/gl.h>", "#  include <gl.h>"
        s.gsub! "#  include <GL/glu.h>", "#  include <glu.h>", false
      end
    end

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-update-desktop-database
      --disable-update-mime-database
    ]
    args << "--disable-doc" if build.without? "doc"
    args << "--disable-gl" if build.without? "opengl"
    args << "--without-x" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pcb --version")
  end
end

__END__
diff --git a/src/hid/common/hidgl.c b/src/hid/common/hidgl.c
index 93c095d..8f58742 100644
--- a/src/hid/common/hidgl.c
+++ b/src/hid/common/hidgl.c
@@ -78,6 +78,7 @@
 #include <dmalloc.h>
 #endif

+typedef GLvoid (*_GLUfuncptr)(GLvoid);

 triangle_buffer buffer;
 float global_depth = 0;

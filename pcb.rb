class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.0.1/pcb-4.0.1.tar.gz"
  sha256 "5d1bd189d8f9b362ac0890ea7ce826e77e61f724439d83c9f854f9c782ca7ef5"
  version_scheme 1
  head "git://git.geda-project.org/pcb.git"

  bottle do
    sha256 "968b7aed3801952c16a51f87d6faddc51dd96dbff154fa9c47fb28f81d809dbb" => :sierra
    sha256 "df54df9cf02b11f50b3f106bdcdb26def3f5ec6bea807e26e57e4b2268f5d92c" => :el_capitan
    sha256 "64ee041b71af0bd5993c1f0f1584f1b32fd969f151955e3bfd0ad174c8de4e74" => :yosemite
  end

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

class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-20140316/pcb-20140316.tar.gz"
  sha256 "82c4f39438ee4e278196a3b67ef021145dcfbb00519508ccf51aa7832121c950"
  revision 3

  head "git://git.geda-project.org/pcb.git"

  bottle do
    sha256 "afffa8b991dc0d8dedeabf4d97869ef294a9a44885ffdeeaafd0da1425150d02" => :el_capitan
    sha256 "21b557b5ec551b01f8845a9166feff7e0bef94a16d93f455f3d057c60cab9d2d" => :yosemite
    sha256 "d83abec9b548ffb5268cfa39810ac902c9dd3daddf890f30459ab19f9078a976" => :mavericks
  end

  option "with-doc", "Build the documentation (requires LaTeX)."
  option "without-opengl", "Configure pcb without OpenGL, may fix garbled screen."

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

  conflicts_with "gts", :because => "both install `include/gts.h`"

  patch :DATA

  def install
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

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pcb --version")
  end
end

# There's a missing define from GLU. Defining this fixes everything up.
__END__
diff --git a/src/hid/common/hidgl.c b/src/hid/common/hidgl.c
index 15273a6..ff73ca7 100644
--- a/src/hid/common/hidgl.c
+++ b/src/hid/common/hidgl.c
@@ -66,6 +66,7 @@
 #include <dmalloc.h>
 #endif

+typedef GLvoid (*_GLUfuncptr)(GLvoid);

 triangle_buffer buffer;
 float global_depth = 0;

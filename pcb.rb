class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-20140316/pcb-20140316.tar.gz"
  sha256 "82c4f39438ee4e278196a3b67ef021145dcfbb00519508ccf51aa7832121c950"
  revision 2
  head "git://git.geda-project.org/pcb.git"

  bottle do
    sha256 "05c29d809655adb5163eb478ab6060b72cf77259e5cb3d3c1262cecd18ac04e8" => :el_capitan
    sha256 "2eac5a8a6e330efa7bf88e7fba920f3592123a043e1d65e2fdd90222f430b21e" => :yosemite
    sha256 "c4780408f8329a24f147a955dc29d9ec2c7ab133c6b49cb028b91f8410e522e9" => :mavericks
  end

  option "with-doc", "Build the documentation (requires LaTeX)."
  option "without-opengl", "Configure pcb without OpenGL, may fix garbled screen."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "d-bus"
  depends_on "gtk+"
  depends_on "gd"
  depends_on "glib"
  depends_on "gtkglext"
  depends_on :tex if build.with? "doc"

  conflicts_with "gts", :because => "both install `include/gts.h`"

  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-update-desktop-database",
            "--disable-update-mime-database"]
    args << "--disable-doc" if build.without? "doc"
    args << "--disable-gl" if build.without? "opengl"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pcb", "--version"
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

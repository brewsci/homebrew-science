class Pcb < Formula
  desc "An interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-20140316/pcb-20140316.tar.gz"
  sha256 "82c4f39438ee4e278196a3b67ef021145dcfbb00519508ccf51aa7832121c950"
  head "git://git.geda-project.org/pcb.git"
  revision 1

  bottle do
    sha256 "0953f1af259dd756520288d7a961d767769f75e835d3f1e039d9b3bac893d737" => :yosemite
    sha256 "2cca7e51f52c188d862d5b90fdd3ccf189cfd743d535c028a826486bc58be420" => :mavericks
    sha256 "41cc4c897447b24f0840501456cce0b9b5a57be1d0a9dce14de2686b98528a42" => :mountain_lion
  end

  option "with-doc", "Build the documentation (requires LaTeX)."

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

class Ggobi < Formula
  desc "A visualization program for exploring high-dimensional data"
  homepage "http://www.ggobi.org"
  url "http://www.ggobi.org/downloads/ggobi-2.1.11.tar.bz2"
  sha256 "2c4ddc3ab71877ba184523e47b0637526e6f3701bd9afb6472e6dfc25646aed7"

  bottle do
    sha256 "e63b0d69aae19e59652a7661f568505164c192168e3ddf1db16ffd33cf75ffb4" => :yosemite
    sha256 "9af14eb802acb8bd7b063ad778fe5d9d44d93ee031a39bdc12737a2a84017c2a" => :mavericks
    sha256 "d22248e9494659675b6a7d41019b5a7f75d6f369658d577226eba80fa53f9cb4" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gettext"
  depends_on "libtool" => :run

  def install
    # Necessary for ggobi to build - based on patch from MacPorts
    # See: https://trac.macports.org/export/64669/trunk/dports/science/ggobi/files/patch-src-texture.diff
    # Reported at https://groups.google.com/d/msg/ggobi/0yiepEUgjiM/nXTVoMaAzj8J
    inreplace "src/texture.c", "psort", "p_sort"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-all-plugins"
    system "make", "install"
  end

  test do
    # executable (GUI)
    system "#{bin}/ggobi", "--version"
    # API
    (testpath/"test.c").write <<-EOS.undent
      #include <GGobiAPI.h>

      int main(int argc, char *argv[]) {
        const char *string = GGobi_getVersionString();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/ggobi
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lggobi
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

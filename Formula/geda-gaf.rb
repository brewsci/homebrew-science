class GedaGaf < Formula
  desc "Toolkit of electronic design automation tools"
  homepage "http://www.geda-project.org/"
  url "http://ftp.geda-project.org/geda-gaf/stable/v1.8/1.8.2/geda-gaf-1.8.2.tar.gz"
  sha256 "bbf4773aef1b5a51a8d6f4c3fa288c047340cc62dd6e14d7928fcc6e4051b721"
  revision 2

  bottle do
    sha256 "66d413cea61d456320f304f145115c841a68e0f4edcd21562ad3827314121576" => :sierra
    sha256 "2e98acffbbd3920cd66eab256e3ceace0e2337a7a61eaa504a48cf58e6a206df" => :el_capitan
    sha256 "37b19c3e1b3ee996f9162519dbc078f1d46939e5d7afcff966db05a1ba97ab7c" => :yosemite
  end

  devel do
    url "http://ftp.geda-project.org/geda-gaf/unstable/v1.9/1.9.1/geda-gaf-1.9.1.tar.gz"
    sha256 "563c4ae8ba72824e873094d9133425b8f142f7e5b25cd6da33f69b2d99c980a3"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "guile@2.0"
  depends_on "gawk"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-update-xdg-database",
                          "--with-pcb-datadir=#{HOMEBREW_PREFIX}/share/pcb"
    system "make"
    system "make", "install"
  end

  test do
    # executable test (GUI)
    system "#{bin}/gschem", "--version"
    # API test
    (testpath/"test.c").write <<-EOS.undent
      #include <libgeda/libgeda.h>

      int main(int argc, char *argv[]) {
        GedaList *geda_list_new( void );
        return 0;
      }
    EOS
    bdw_gc = Formula["bdw-gc"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gmp = Formula["gmp"]
    guile = Formula["guile@2.0"]
    libpng = Formula["libpng"]
    readline = Formula["readline"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{bdw_gc.opt_include}
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gmp.opt_include}
      -I#{guile.opt_include}/guile/2.0
      -I#{include}
      -I#{libpng.opt_include}/libpng16
      -I#{readline.opt_include}
      -D_REENTRANT
      -D_THREAD_SAFE
      -L#{bdw_gc.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{guile.opt_lib}
      -L#{lib}
      -lgc
      -lgdk_pixbuf-2.0
      -lgeda
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lguile-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

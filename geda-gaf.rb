class GedaGaf < Formula
  desc "Toolkit of electronic design automation tools"
  homepage "http://www.geda-project.org/"
  url "http://ftp.geda-project.org/geda-gaf/stable/v1.8/1.8.2/geda-gaf-1.8.2.tar.gz"
  sha256 "bbf4773aef1b5a51a8d6f4c3fa288c047340cc62dd6e14d7928fcc6e4051b721"
  revision 1

  bottle do
    sha256 "7d3fb8d1db90b65a695bc75538eacac8f5d6a11b0a89ef8e569607b5944089ba" => :el_capitan
    sha256 "afbc92df8c10e4c0516732f0d1625273490cdb86448bc67e5b7aabfca2aad933" => :yosemite
    sha256 "9637b73920afbaaa1a92d0b8c852d5ff2ed435122a755ee8ad2fe1cc142bbcda" => :mavericks
  end

  devel do
    url "http://ftp.geda-project.org/geda-gaf/unstable/v1.9/1.9.1/geda-gaf-1.9.1.tar.gz"
    sha256 "563c4ae8ba72824e873094d9133425b8f142f7e5b25cd6da33f69b2d99c980a3"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "guile"
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
    guile = Formula["guile"]
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

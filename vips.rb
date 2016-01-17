class Vips < Formula
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/vips-8.2.1.tar.gz"
  sha256 "bcedee8cd654b26591e08c7085758764358c12fdf1a2141cd5e539a046365928"
  revision 1

  bottle do
    sha256 "72c8c3137ab75a2942145f2c9fdb3c23cc497dd70433b6f1062efed051dd1fa9" => :el_capitan
    sha256 "2584dda14e2e7bc609f1e5ad7fbc010589fefdb57a4ef3e6e66b3e062cc73c6b" => :yosemite
    sha256 "ace28caf618dccfda3ba4719e35aa30c399c464635bba378884e80f6ae10a507" => :mavericks
  end

  option "without-check", "Disable build time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "glib"

  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "orc" => :recommended
  depends_on "libgsf" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "fftw" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "pango" => :recommended
  depends_on "libexif" => :recommended
  depends_on "gobject-introspection" => :recommended
  depends_on "pygobject3" => :recommended
  depends_on "python" => :recommended

  depends_on "openslide" => :optional
  depends_on "imagemagick" => :optional
  depends_on "graphicsmagick" => :optional
  depends_on "openexr" => :optional
  depends_on "cfitsio" => :optional
  depends_on "webp" => :optional
  depends_on "python3" => :optional
  depends_on "libmatio" => :optional
  depends_on "mozjpeg" => :optional
  depends_on "jpeg-turbo" => :optional

  # Bugfix from commit 4512400 for bilinear interpolation rounding error.
  # Remove when 8.2.2 is released.
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args.concat %w[--with-magick --with-magickpackage=GraphicsMagick] if build.with? "graphicsmagick"

    system "./configure", *args
    if build.with? "check"
      # Test scripts fail with non-english decimal separator, see jcupitt/libvips#367
      ENV["LC_NUMERIC"] = "C"
      system "make", "check"
    end
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    system "#{bin}/vipsheader", test_fixtures("test.png")
  end
end

__END__
diff --git a/libvips/resample/interpolate.c b/libvips/resample/interpolate.c
index 52d24dc..354c8a9 100644
--- a/libvips/resample/interpolate.c
+++ b/libvips/resample/interpolate.c
@@ -430,7 +430,8 @@ G_DEFINE_TYPE( VipsInterpolateBilinear, vips_interpolate_bilinear,

 #define BILINEAR_INT_INNER { \
	tq[z] = (sc1 * tp1[z] + sc2 * tp2[z] + \
-		 sc3 * tp3[z] + sc4 * tp4[z]) >> VIPS_INTERPOLATE_SHIFT; \
+		 sc3 * tp3[z] + sc4 * tp4[z] + \
+		 (1 << VIPS_INTERPOLATE_SHIFT) / 2) >> VIPS_INTERPOLATE_SHIFT; \
	z += 1; \
 }

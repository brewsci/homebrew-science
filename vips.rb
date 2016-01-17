class Vips < Formula
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/vips-8.2.1.tar.gz"
  sha256 "bcedee8cd654b26591e08c7085758764358c12fdf1a2141cd5e539a046365928"
  revision 1

  bottle do
    sha256 "41a5deab9c91f1af826213d3cb4ceb650084cc376e5e0107b64c1f12e2902142" => :el_capitan
    sha256 "bc133647c8552bd260829bde0e030e37d63981102aee2b6dcc82b22dcbdbe22a" => :yosemite
    sha256 "3407cf1605900557078229a1231519c04aa1ffbbf1ab2f930d211592b7daf4cb" => :mavericks
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

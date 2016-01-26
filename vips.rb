class Vips < Formula
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/vips-8.2.2.tar.gz"
  sha256 "0f688a34e99714ff0901cba8cdf93ec9878447e33dea122f4b226416550a6389"

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

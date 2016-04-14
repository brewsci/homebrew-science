class Vips < Formula
  desc "Image processing library"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.3/vips-8.3.0.tar.gz"
  sha256 "d6ca79b1c5d78f33ebb6d7d3d6948a3bd7ade1c0e09fd162707b1023e17243ec"

  bottle do
    sha256 "6cf11425e98a8a4cf1481384ceb013ac06bb70f70b700c3e2d863d6930d5b8d2" => :el_capitan
    sha256 "a30e35fb6830ad6f979d76dec1eba77aafee94505dfec9d983c789d0b91c9d43" => :yosemite
    sha256 "99cd35942ac211a93ed22adad5ab7322ab3f16664cba16c9d420c58aad99501b" => :mavericks
  end

  option "without-test", "Disable build time checks (not recommended)"
  deprecated_option "without-check" => "without-test"

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
  depends_on "poppler" => :recommended
  depends_on "librsvg" => :recommended
  depends_on "giflib" => :recommended

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

class Vips < Formula
  desc "Image processing library"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.3/vips-8.3.0.tar.gz"
  sha256 "d6ca79b1c5d78f33ebb6d7d3d6948a3bd7ade1c0e09fd162707b1023e17243ec"

  bottle do
    revision 1
    sha256 "2f6e73d5534da822a325c2beefeb1209af71530e5365ce9222aeaeab9291759a" => :el_capitan
    sha256 "8540d070468252f607eb19c9aa8d48dd3dd8db547e3cfeee0d2e8dfcde8ce4aa" => :yosemite
    sha256 "5a9399a528ab844818c90618fc41740900fc28291bfe68d9e951a755f8fc1ae7" => :mavericks
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

  # Fix build --with-graphicsmagick, see jcupitt/libvips#423
  patch do
    url "https://gist.githubusercontent.com/felixbuenemann/6862526323514cb7684b81cb88593d0d/raw/5d3d258f4c8c316f7c897eb5b91da771704665d2/vips-8.3.0-graphicsmagick-fix.diff"
    sha256 "8a7a43e9faebb38ecc8cfe4f8f1fc20ca53bc758f289b62693700818a5eb1b34"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args.concat %w[--with-magick --with-magickpackage=GraphicsMagick] if build.with? "graphicsmagick"

    system "./configure", *args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    system "#{bin}/vipsheader", test_fixtures("test.png")
  end
end

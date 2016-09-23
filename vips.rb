class Vips < Formula
  desc "Image processing library"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.4/vips-8.4.1.tar.gz"
  sha256 "3e7021db2df099736c02aaf48211ca5f306371af75e9878a35bbcf06742cbb6e"

  bottle do
    sha256 "4df6ebfb2d67d5851143624bc83a6e85225e5068f620cfe3655d6c543a8f555e" => :el_capitan
    sha256 "1e2e97e5fbc3aefefcbe1d461043482def52bfb82c128b7dd67f26264298cb9b" => :yosemite
    sha256 "7fa1924dff280edb89c36d5d1798961616b9d94f6785c28e9eab18bf8751b9a5" => :mavericks
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
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    system "#{bin}/vipsheader", test_fixtures("test.png")
  end
end

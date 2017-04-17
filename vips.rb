class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.3/vips-8.5.3.tar.gz"
  sha256 "606ca1b33bdda57bea76b6f62f5c92d0d0f9b5904da3835d7ec6ed5b10c59fbc"

  bottle do
    sha256 "efb352552111d240990d7863242cb9999ef215452690e5047dd36f6fc915461f" => :sierra
    sha256 "a975eaec8b5af0d0a52f8814df443405ffa930bb0254d0b297110c0f78b7e633" => :el_capitan
    sha256 "c352ab87d0c35da9aba77d0a8a40dc15197c48992cebf8dc16fea2946978d8e9" => :yosemite
    sha256 "ab70e9f07c3bcf62693fc9ccb8fe5d49ea023e4021526e21c4e9a7fa4d593307" => :x86_64_linux
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

class Vips < Formula
  desc "Image processing library"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.3/vips-8.3.2.tar.gz"
  sha256 "6f5f4129e25a86ec46a8d15576bffe0ee700d56455c80fcb3e2f02fa49359d4a"

  bottle do
    sha256 "7f7f80c38e844389d45aea55d354ebbbf5ef5efdefa64b5a00c5afe782215d7d" => :el_capitan
    sha256 "2829062d07d8ed719e11fd37f7af7fa93f934de720d1e123006cba8644afe643" => :yosemite
    sha256 "5f176b75622b919f4af58403983f76e1a638ced19d41db6ee05fb6afbe5108ed" => :mavericks
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

  depends_on "cairo" => :linked
  depends_on "freetype" => :linked
  depends_on "gdk-pixbuf" => :linked

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

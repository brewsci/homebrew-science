class Vips < Formula
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.1/vips-8.1.1.tar.gz"
  sha256 "7d53c9b1e2ecd87ab9a7ccc9abad8b3a4f2575115b8a2066a15b0c24f17d9a04"

  bottle do
    sha256 "664c00d8efb0b616179df3103931b5b8577eae07b05179213873b585f9d442c7" => :el_capitan
    sha256 "627bc3f8f4692eff6a675e3b1fbe60b5b5b295523a0b40219acfb0488712f0a8" => :yosemite
    sha256 "b05dcae773264c6d6973d862c16a8bc25680bb0ff4d272796c3b4a327c13d0c4" => :mavericks
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

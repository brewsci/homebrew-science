class Vips < Formula
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.0/vips-8.0.2.tar.gz"
  sha256 "1e6d102b425685467f58003f9d41cd097b772cdf50b4d7995f73751dce86fa3a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "2b94e9380aeab4f5d563cefc8cb27d82d640c656978934b00bc8c5e5fed279b9" => :yosemite
    sha256 "374783e313c669962feeb7f506088554e830e29e2020a95ea80420008d421263" => :mavericks
    sha256 "6e95a70bb84215775810b2c296a18aa9cc3534a48b359434019a7d010f2c8fb6" => :mountain_lion
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

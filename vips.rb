class Vips < Formula
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.0/vips-8.0.2.tar.gz"
  sha256 "1e6d102b425685467f58003f9d41cd097b772cdf50b4d7995f73751dce86fa3a"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "277998919346d9192b49e9cf77938d83ed5965c1e082e4bc609eaf459178e7ce" => :yosemite
    sha256 "4102d4f73fc6a2f3463ee6701183b544c3775104e6df481567b200f1d016302b" => :mavericks
    sha256 "e2b090c7561349998d3a162a375821534bc0656eb4266bff281ff451e4cee4ff" => :mountain_lion
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
    system "#{bin}/vips", "list", "classes"
    system "#{bin}/vipsheader", test_fixtures("test.png")
  end
end

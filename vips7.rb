class Vips7 < Formula
  desc "Vips Version 7"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/7.42/vips-7.42.3.tar.gz"
  sha256 "6d001480b75a20d04d44869fb4cb93e4203e73ecd865dc68b1c11f56c9e74baa"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "990f0754c31b59f6c1717df32b51aab982fab1b94b050b9e76875f460c36aa08" => :yosemite
    sha256 "65abd59e09cea2dec766ad72feb9ab8fa30b9797856e2a959385c2526617d45c" => :mavericks
    sha256 "5eeb413ec0895891058c0da0f2fb1a437f7dad792a9cb51d8e6a45d4e1fb5bee" => :mountain_lion
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

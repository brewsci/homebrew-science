class Vips < Formula
  desc "Image processing library"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/vips-8.2.3.tar.gz"
  sha256 "4bc986d496a0fe5e50e3c78e86b8f8dc445590a13b155be0f4b1d9432a51bfa2"

  bottle do
    sha256 "27f3767c5faec611d09350fd94ab645dbd08e5023b2fa99cf6452eb207271392" => :el_capitan
    sha256 "26ffee29d527ec276119a9514f3279c254ea58ff72c00128c6bc7cde0bf28b43" => :yosemite
    sha256 "b61fa5e4217cd376ae064d6c73b9255aa607ab180d43c74309c2f53b2a69d8d6" => :mavericks
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

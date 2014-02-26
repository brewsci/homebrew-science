require 'formula'

class Vips < Formula
  homepage 'http://www.vips.ecs.soton.ac.uk/'
  url 'http://www.vips.ecs.soton.ac.uk/supported/7.38/vips-7.38.5.tar.gz'
  sha1 'c55ab4c4a42d3bcd40c6c03e38ead13f71c97fc0'

  option 'without-check', 'Disable build time checks (not recommended)'

  depends_on 'pkg-config' => :build
  depends_on :fontconfig
  depends_on 'gettext'
  depends_on 'glib'
  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'orc' => :recommended
  depends_on 'openslide' => :optional
  depends_on 'libtiff' => :recommended
  depends_on 'imagemagick' => :optional
  depends_on 'graphicsmagick' => :optional
  depends_on 'fftw' => :recommended
  depends_on 'little-cms' => :recommended
  depends_on 'pango' => :recommended
  depends_on 'libexif' => :recommended
  depends_on 'openexr' => :optional
  depends_on 'cfitsio' => :optional
  depends_on 'webp' => :optional

  def install
    args = [ "--disable-dependency-tracking",
             "--prefix=#{prefix}"]

    args.concat ['--with-magick', '--with-magickpackage=GraphicsMagick'] if build.with? 'graphicsmagick'
    system "./configure", *args
    system 'make', 'check' if build.with? 'check'
    system 'make', 'install'
  end
end

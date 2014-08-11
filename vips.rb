require 'formula'

class Vips < Formula
  homepage 'http://www.vips.ecs.soton.ac.uk/'
  url "http://www.vips.ecs.soton.ac.uk/supported/7.40/vips-7.40.5.tar.gz"
  sha1 "af1ddabe3763d68f65c085fc0bcb021d02b4f8a2"

  option 'without-check', 'Disable build time checks (not recommended)'

  depends_on 'pkg-config' => :build
  depends_on :fontconfig
  depends_on 'gettext'
  depends_on 'glib'

  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'orc' => :recommended
  depends_on 'libgsf' => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'fftw' => :recommended
  depends_on 'little-cms' => :recommended
  depends_on 'pango' => :recommended
  depends_on 'libexif' => :recommended

  depends_on 'openslide' => :optional
  depends_on 'imagemagick' => :optional
  depends_on 'graphicsmagick' => :optional
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

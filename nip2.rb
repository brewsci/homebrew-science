class Nip2 < Formula
  desc "A GUI for the VIPS image processing system"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/7.42/nip2-7.42.1.tar.gz"
  sha256 "541e95a4a8bb3f8ee850035c6beb8a67fe7e174df6c58032fa99ebaf80f58e92"

  option "with-check", "Enable build-time checking"

  depends_on "pkg-config" => :build
  depends_on "XML::Parser" => :perl
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libxml2"
  depends_on "vips"

  depends_on "fftw" => :recommended
  depends_on "gsl" => :recommended
  depends_on "goffice" => :recommended
  depends_on "libgsf" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    # when first run, nip2 tries to create ~/Library/nip2-x.y.z
    # to hold temp files ... ~/Library is not present in homebrew's
    # private test home directory
    require "fileutils"
    mkdir_p ENV["HOME"] + "/Library"

    system "#{bin}/nip2", "--benchmark"
  end
end

class Nip2 < Formula
  desc "A GUI for the VIPS image processing system"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/nip2-8.2.tar.gz"
  sha256 "18151e2185eb9db60196d98354ef751eb55ea9d3b55ef090f4a039125d465fca"
  revision 1

  bottle do
    cellar :any
    sha256 "517799012b227b2073c42927aaa9c4c4e99ddbcbeb72f0e422e15168b46384e3" => :el_capitan
    sha256 "d7bee2898d6d4fd1482ac7820c2bf01638744f01ab17d5e14379f134b588990a" => :yosemite
    sha256 "ada6912ef86789eec29a19aa883ae2fecfbbe0ea7d597d2c74db22da56b58c7c" => :mavericks
  end

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

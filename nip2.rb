class Nip2 < Formula
  desc "A GUI for the VIPS image processing system"
  homepage "http://www.vips.ecs.soton.ac.uk/"
  url "http://www.vips.ecs.soton.ac.uk/supported/8.2/nip2-8.2.tar.gz"
  sha256 "18151e2185eb9db60196d98354ef751eb55ea9d3b55ef090f4a039125d465fca"
  revision 1

  bottle do
    cellar :any
    sha256 "20d379cce240bb99db2e40a8ba8158daa804c9f6f9b7ca0f653ca7f99b903c06" => :el_capitan
    sha256 "9aedd3b2ea45252cccd768c4a00dcc72017a0033d96954b1bc6f7d6f198f3323" => :yosemite
    sha256 "651eb4cd587a533590a38cf068f64c86c7504fa9b32df93148874bb7eef3931d" => :mavericks
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

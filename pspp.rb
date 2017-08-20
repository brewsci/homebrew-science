class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "https://ftp.gnu.org/gnu/pspp/pspp-1.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/pspp/pspp-1.0.1.tar.gz"
  sha256 "ba281a2e5d7d40e22f36f07f434a4fbc5be49c6d15740b121c299d024aae1ae5"

  bottle do
    sha256 "c0a05236ea6b388daee9cb3c2611ddc3587aca0b17e8ce832f6f75fb668ff9d5" => :sierra
    sha256 "55958d3fc017b8b66f686af87221e934d5be7158cbec26a5a95772e359e90bad" => :el_capitan
    sha256 "127dc888bf83cfe013e6fbba23ae72f4cd41de29140c7ccd4aeb1019b040b838" => :yosemite
    sha256 "bd34b7a325dd94c448ec4da89e3e879b3c51852dbdf340852524dc97e0f8e8b0" => :x86_64_linux
  end

  option "without-test", "Skip running the PSPP test suite"
  option "without-gui", "Build without GUI support"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build

  depends_on "gsl"
  depends_on "glib"
  depends_on "gettext"
  depends_on "readline"
  depends_on "libxml2"
  depends_on "cairo"
  depends_on "pango"

  depends_on "postgresql" => :optional

  if build.with? "gui"
    depends_on "gtk+"
    depends_on "gtksourceview3"
    depends_on "freetype"
    depends_on "fontconfig"
  end

  def install
    args = ["--disable-rpath"]
    args << "--without-libpq" if build.without? "postgresql"
    args << "--without-gui" if build.without? "gui"
    args << "--without-perl-module" # not built by default but tests run for it

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pspp", "--version"
  end
end

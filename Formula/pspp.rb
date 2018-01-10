class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "https://ftp.gnu.org/gnu/pspp/pspp-1.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/pspp/pspp-1.0.1.tar.gz"
  sha256 "ba281a2e5d7d40e22f36f07f434a4fbc5be49c6d15740b121c299d024aae1ae5"

  bottle do
    sha256 "16197a2755fcf8c15a57d8caea5994862073437b39de7b921ea695090e661d52" => :sierra
    sha256 "303af89c5baba2a558659ed6b83b8eef8ebdccc68500a7e007e0093ae6f00911" => :el_capitan
    sha256 "199674bd2b1d4a42285edceab3239cdabdede267269fa6750d42dd65d5c2d9a0" => :yosemite
    sha256 "bf38c1cb76fc83069460792a930335b940564a9e36abca63882b03d54e803c67" => :x86_64_linux
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

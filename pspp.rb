class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "http://ftpmirror.gnu.org/pspp/pspp-0.8.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pspp/pspp-0.8.5.tar.gz"
  sha256 "e7efd2ffa58882e97f719cb403d84683751c913cc2ca133b49b1c5e9bd110331"

  bottle do
    sha256 "de81367499dae0031cbab3a3421dc2817f884a1e7ba92a69aa6707e00ef9d63e" => :yosemite
    sha256 "78e70c08f4f537fafd7c0f297926bb17776c89acc3b1318125b94e9398090db4" => :mavericks
    sha256 "a66ac66e4dbf4426ef2ecb849b9f02462db0f0715a5726dae0111adb01303c31" => :mountain_lion
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
    depends_on "gtksourceview"
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

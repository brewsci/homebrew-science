class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "https://ftpmirror.gnu.org/pspp/pspp-0.10.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pspp/pspp-0.10.2.tar.gz"
  sha256 "f77cacae6948689a60f1a5808a5d2e183c1cd0847c7fc6142646c63814c0daa9"
  revision 2

  bottle do
    sha256 "74e7134c04699d36bbe4ac066d6d7fa0d7b40ba378eb87bfcb51ee4321faaa58" => :sierra
    sha256 "d0d6762cc94be1193e07eb492c57ce69eb7119df3defd227520e791ce4f93d52" => :el_capitan
    sha256 "62aa35d54136a0879cacb151ce9e4d0fe31fba280756adb16be30cfc59eb846c" => :yosemite
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

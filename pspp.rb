class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "http://ftpmirror.gnu.org/pspp/pspp-0.10.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pspp/pspp-0.10.2.tar.gz"
  sha256 "f77cacae6948689a60f1a5808a5d2e183c1cd0847c7fc6142646c63814c0daa9"

  bottle do
    sha256 "bc080b73c3eec57444db490c9bed2a78378d282818716de6f9379e5b0744ff14" => :el_capitan
    sha256 "e3f0e23ec13b11c61b46e88946c99737f9da99a5c59776816edbd076cbb91b19" => :yosemite
    sha256 "4ea5e8f5ed67e4b8ff74168385be5efe8b1c83fc51d07ac439a3be58bab5a9bf" => :mavericks
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

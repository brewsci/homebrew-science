class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "https://ftpmirror.gnu.org/pspp/pspp-0.10.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pspp/pspp-0.10.2.tar.gz"
  sha256 "f77cacae6948689a60f1a5808a5d2e183c1cd0847c7fc6142646c63814c0daa9"
  revision 1

  bottle do
    sha256 "29155939c2351f285697bf17bce5f25ea9c2704116bb9d633759ae05e0923eff" => :el_capitan
    sha256 "40577dce7827cd38caf880a7812ed2245d7e16de4c1fdd8daa2366360f308c23" => :yosemite
    sha256 "b667543806facb540c2ebadd90ad66d6c644f5651c50f585ca3ada036730f32b" => :mavericks
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

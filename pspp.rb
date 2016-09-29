class Pspp < Formula
  desc "Statistical analysis of sampled data (FOSS SPSS clone)"
  homepage "https://www.gnu.org/software/pspp/"
  url "https://ftpmirror.gnu.org/pspp/pspp-0.10.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/pspp/pspp-0.10.2.tar.gz"
  sha256 "f77cacae6948689a60f1a5808a5d2e183c1cd0847c7fc6142646c63814c0daa9"
  revision 2

  bottle do
    sha256 "c788733e5382a9a9756cf53bd580936b0e6a613f6bbc982dc10b139d63bf2b9a" => :el_capitan
    sha256 "93d8f790a38b07904010dc1119bd1bc5347d8b3225e63c0d8162c52499d9b64b" => :yosemite
    sha256 "c5f5fe5fe033f4f88290a54c8b8dffe126a52fa79523d60609d79ff798bc7675" => :mavericks
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

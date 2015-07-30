class Libfolia < Formula
  desc "XML annotation format for linguistically annotated language resources"
  homepage "https://proycon.github.io/folia/"
  url "http://software.ticc.uvt.nl/libfolia-0.13.tar.gz"
  sha256 "a9fc9e475bb79629dc014cf7a78af64486c0f1bb902821ba2bb36c38c77a5d24"

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "ticcutils"
  depends_on "libxslt"
  depends_on "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

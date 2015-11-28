class Libfolia < Formula
  desc "XML annotation format for linguistically annotated language resources"
  homepage "https://proycon.github.io/folia/"
  url "http://software.ticc.uvt.nl/libfolia-0.13.tar.gz"
  sha256 "a9fc9e475bb79629dc014cf7a78af64486c0f1bb902821ba2bb36c38c77a5d24"
  revision 1

  bottle do
    cellar :any
    sha256 "f1001f3278477f88968038d0a722cb851c334653bcf55ca67f599a5482274b5a" => :el_capitan
    sha256 "ed3ce3438a5f10bbae88d8224f672f7968882c5ef822af4650d4db92ac5b9d2f" => :yosemite
    sha256 "4d541070af9aabc2bce4b1a46f3ad9360a7d6e9fc6e5128c074e77ed94d9fd42" => :mavericks
  end

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

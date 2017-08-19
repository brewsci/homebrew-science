class Libfolia < Formula
  desc "XML annotation format for linguistically annotated language resources"
  homepage "https://proycon.github.io/folia/"
  url "https://github.com/LanguageMachines/libfolia/releases/download/v1.8/libfolia-1.8.tar.gz"
  sha256 "144051c5d590d7779a6a8b6825df58ab1c78889565a9fb04cd0f4a6e90d0f5a8"

  bottle do
    cellar :any
    sha256 "891bc62ca54b0b52986306581961c91f950e4515b83871ba9413ff9844f72284" => :sierra
    sha256 "4877bfe918dc8da7ab692a326dafd799af4c3afee61dd95ace30c336ff9ca2a5" => :el_capitan
    sha256 "c27731540421d91cef104102fc9d21acf329c05cdd79672adcf5f3a412239333" => :yosemite
  end

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "ticcutils"
  depends_on "libxslt"
  depends_on "libxml2"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

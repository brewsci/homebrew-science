class Libfolia < Formula
  desc "XML annotation format for linguistically annotated language resources"
  homepage "https://proycon.github.io/folia/"
  url "https://github.com/LanguageMachines/libfolia/releases/download/v1.11/libfolia-1.11.tar.gz"
  sha256 "0e716281802df050bcced4826b470152308f7be93ce481f8f47528abafa1e2e1"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, high_sierra:  "0db59fd9d1f80c6616d5b7935e9d5f3307cbaa2fec366740a768efabd3794e3c"
    sha256 cellar: :any, sierra:       "c67dbd706bfe1af2ca072e61243f460e89b3b00e80207ef1513bb163269b7a8e"
    sha256 cellar: :any, el_capitan:   "25bb602a0d4d757aa91779948cc25f589a0475b32e14d4c0d1527a15a5d0d0a8"
    sha256 cellar: :any, x86_64_linux: "bfd9792fb8767d6f042bb333ef6c4d09d22640c10dc48af71ca77d74954edf1e"
  end

  option "without-test", "skip build-time checks (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "ticcutils"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end

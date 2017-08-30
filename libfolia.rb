class Libfolia < Formula
  desc "XML annotation format for linguistically annotated language resources"
  homepage "https://proycon.github.io/folia/"
  url "https://github.com/LanguageMachines/libfolia/releases/download/v1.9/libfolia-1.9.tar.gz"
  sha256 "d22376bc7528f00a98fe7444cbdf089051fa4a3922cddd8d2854dcf35dad9a07"

  bottle do
    cellar :any
    sha256 "d8d7ede00a144bb455a74e6aea6c1f13f8ef7b45b6dd6bf7239b4f9cdda9f509" => :sierra
    sha256 "779e80cf33b7950bdfc9a46dc945e299ccb0ac0462f9b0dbf2e6d2987c278ef2" => :el_capitan
    sha256 "b2055f827fefb199089e14b4dfada81fb77c49e8ddf5d46428ccef58107e4b2b" => :yosemite
  end

  option "without-test", "skip build-time checks (not recommended)"

  deprecated_option "without-check" => "without-test"

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
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end

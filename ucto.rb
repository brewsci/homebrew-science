class Ucto < Formula
  desc "Unicode tokenizer"
  homepage "http://ilk.uvt.nl/ucto/"
  url "http://software.ticc.uvt.nl/ucto-0.8.0.tar.gz"
  sha256 "d3de9886aac95b5eaa48c45a6f8e69e3bb0c350f1d827987e802f4a2ccbcd0bc"

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libfolia"
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

class Ucto < Formula
  desc "Unicode tokenizer"
  homepage "http://ilk.uvt.nl/ucto/"
  url "http://software.ticc.uvt.nl/ucto-0.8.0.tar.gz"
  sha256 "d3de9886aac95b5eaa48c45a6f8e69e3bb0c350f1d827987e802f4a2ccbcd0bc"
  revision 1

  bottle do
    sha256 "d1cdf45fc49ed34d8c5a8e6e860a3248421c760a9c8895645cbbc4b4fbb3a1e7" => :el_capitan
    sha256 "48250e654b37bc9055d87f57116f458e49e5765cfb8d2f879e83e50fc4a63126" => :yosemite
    sha256 "869c3fda2b9d58aef0cabfd26f3bf3398f7c93332a2911358892c9f551703d03" => :mavericks
  end

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

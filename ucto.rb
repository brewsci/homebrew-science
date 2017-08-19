class Ucto < Formula
  desc "Unicode tokenizer"
  homepage "https://ilk.uvt.nl/ucto/"
  url "https://github.com/LanguageMachines/ucto/releases/download/v0.9.6/ucto-0.9.6.tar.gz"
  sha256 "c10b19f6f6de36cb22a61e663f6b0eaf1aa6fe6557989edce4a30ed28fc3eb64"

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

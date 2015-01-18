class Libsequence < Formula
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.8.3-1.tar.gz"
  version "1.8.3-1"
  sha1 "e31e5ba18ea27a4ec363a64fd5cf38cf5c69aa21"
  head "https://github.com/molpopgen/libsequence.git"

  depends_on "boost" => :build
  depends_on "gsl"

  def install
    ENV.libcxx if MacOS.version < :mavericks

    system "./configure", "--enable-shared=no", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.9.1.tar.gz"
  sha256 "4432b50c63ff8fa05b39500ac7708276ccb6d30abfb5ea43d1c602108ff28733"
  revision 1
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    cellar :any
    sha256 "1434a30c00e75326381eb19c7ffeb29a55d72f2274da2d71637ddba185c38cf9" => :sierra
    sha256 "0b5fbba621a5bfaa307044cad80f89908f0dbebca3952f360b06be8c73657b75" => :el_capitan
    sha256 "fbf75d13002a01c881ad2e6781e168a29b116ee297e5b9f616a076ad8c286d04" => :yosemite
    sha256 "6c19e551e726f5bd24350d2285b3efd779011d98ebbb729042656e2fa61a6719" => :x86_64_linux
  end

  cxx11 = OS.linux? || MacOS.version > :mountain_lion ? [] : ["c++11"]

  depends_on "boost" => cxx11
  depends_on "gsl"
  depends_on "tbb"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--docdir=#{doc}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    ENV.deparallelize { system "make", "check" }
    system "make", "install"
  end
end

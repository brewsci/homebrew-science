class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.9.2.tar.gz"
  sha256 "e7232c969bf9dabab86cd6c592c80de521cc15287252e3a996e63d24028cdd40"
  head "https://github.com/molpopgen/libsequence.git"

  cxx11 = if OS.mac?
    (MacOS.version > :mountain_lion) ? [] : ["c++11"]
  else
    []
  end

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

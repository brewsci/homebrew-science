class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.9.2.tar.gz"
  sha256 "e7232c969bf9dabab86cd6c592c80de521cc15287252e3a996e63d24028cdd40"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    cellar :any
    sha256 "68eb801e1ab47f24b76ca666fb97308cbf3a44628e76c7f8efc4da535ffd9bc8" => :high_sierra
    sha256 "a97325b11c57ef0868674e59ce336e7a08ef08a5ea4985bfbb15b4812d12b728" => :sierra
    sha256 "2cf76ed0b54d947fae9ae83e18070ac105a455214e506aff2163cd8a61b51eba" => :el_capitan
    sha256 "e0ce37efba1d12163f8133296f2c1cb638739a038b386e0911ab5d64ce20b38b" => :x86_64_linux
  end

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

class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.9.1.tar.gz"
  sha256 "4432b50c63ff8fa05b39500ac7708276ccb6d30abfb5ea43d1c602108ff28733"
  revision 2
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    cellar :any
    sha256 "9a472e626aeaf42d749801fa25e32cd15695cbec52081ee677094028595e7373" => :high_sierra
    sha256 "6afdd0e22f7a3aa959a2dcbb77bcdfea9c4e5f384a152f9e6fe7082735f9c0aa" => :sierra
    sha256 "a4b3a022904bcb0fc88d3fe1cd358bbafeaa45afa13413e3e91adb66b5452063" => :el_capitan
    sha256 "e094416f6bd0fc1c8b55aeafa91edeeb93a25969ef44cc442245b0530fe3b8ec" => :x86_64_linux
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

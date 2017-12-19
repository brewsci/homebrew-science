class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.9.1.tar.gz"
  sha256 "4432b50c63ff8fa05b39500ac7708276ccb6d30abfb5ea43d1c602108ff28733"
  revision 3
  head "https://github.com/molpopgen/libsequence.git"

  bottle :disable, "needs to be rebuilt with latest boost"

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

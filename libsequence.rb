class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.9.1.tar.gz"
  sha256 "4432b50c63ff8fa05b39500ac7708276ccb6d30abfb5ea43d1c602108ff28733"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    cellar :any
    sha256 "736edbd7f8aca2418adf0194e4af7aca768c3e15485b9d7e82a11bcef49eb2dc" => :sierra
    sha256 "6aed56c425e88cbba004c429cf0faa66a1cf45bca6f311a4f2bc16e7ee4b751e" => :el_capitan
    sha256 "7dc7bc5f458a6bd23f5ff8dc6d07b317d292432187dc25292500a2482395219e" => :yosemite
    sha256 "3bb378ef36ee025be3cee58aeadb446f69096166e44ff04e42d945ea47a2cefc" => :x86_64_linux
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

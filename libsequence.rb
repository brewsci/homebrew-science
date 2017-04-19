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
    sha256 "36ba91dc8ab3b26cf47ec93146a8cfbe9c76a01e209c534c50d5f7be2808da75" => :sierra
    sha256 "3822cf2d95528eed3082c578954c221fc62460ed656ef4b0e2a1eb4bca1088bf" => :el_capitan
    sha256 "e8dafaaf0a02f854cb369b67cda8a8e9149424a3e61bd482bc285d8c33566b1a" => :yosemite
    sha256 "6b0e9bce99425c68c2026da05734d9e00c404209405538c2f5d382f5680b7101" => :x86_64_linux
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

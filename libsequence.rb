class Libsequence < Formula
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.8.4.tar.gz"
  sha256 "f45a04ae03d8fa6f2eae0a3cec72686028071c851c355e4aab84859bb2cb394a"
  head "https://github.com/molpopgen/libsequence.git"
  revision 1

  bottle do
    cellar :any
    sha256 "20d0a5c889514a6aeacee6e81b857bb42f9a03533a5d3294e3ca510df19aa218" => :el_capitan
    sha256 "1cb31354055aedf42c1013880137df170460a5170634ec32b6130f70c84cafff" => :yosemite
    sha256 "590b3e6113be8d67d1c1cfec48d92337f6736f69ae03c3e138cb9ad70bb39980" => :mavericks
    sha256 "de3d4025d3516cc0efe10bf96fb13813ebccabefe6e7bf52ba07614964b7f178" => :x86_64_linux
  end

  cxx11 = OS.linux? || MacOS.version > :mountain_lion ? [] : ["c++11"]

  depends_on "boost" => cxx11
  depends_on "gsl"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--docdir=#{doc}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end

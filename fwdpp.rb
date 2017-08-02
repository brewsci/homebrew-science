class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.6.tar.gz"
  sha256 "f4a96868ca054364d636792ffb3bce760498b494778b83139bfb985b440df093"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "6e5f147980555dedb9f270f06b609be376c12aa59938d2b3f796039ab1b1e140" => :sierra
    sha256 "33f0fadb7196037c369afa0857b413db0778c2da0ae0c570243d3c9ef0dfd43e" => :el_capitan
    sha256 "c4cc57f490364093e3728a26ff4bb650fe87906007483838ade115a5a899af37" => :x86_64_linux
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  # build fails on Yosemite
  depends_on :macos => :el_capitan

  depends_on "gsl"
  depends_on "libsequence"
  depends_on "boost" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
    pkgshare.install "examples", "testsuite/unit"
  end

  test do
    # run unit tests compiled with 'make check'
    if build.with? "test"
      Dir["#{pkgshare}/unit/*"].each { |f| system f if File.file?(f) && File.executable?(f) }
    end
  end
end

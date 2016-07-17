class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.1.tar.gz"
  sha256 "e29862385d3fabae3efa605f3f09afc2d01c89c7962b609e29952bd84178f904"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "cc8350248223f8f420ad9a5a0180b2602b15f9c8d0f29cf408a7387be7f87c0b" => :el_capitan
    sha256 "4c32ba7d08abe91b5824dbd310fc2b9688434695aa80a031d756757564f0c16b" => :yosemite
    sha256 "f03af30bd365da8c3ff398edc262ee9a91fcda8761fa1bef64fef5e3028503e4" => :mavericks
  end

  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "gsl"
  depends_on "boost" => :recommended
  depends_on "libsequence"

  # build fails on mountain lion at configure stage when looking for libsequence
  # so restrict to mavericks and newer
  depends_on :macos => :mavericks

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
    pkgshare.install "examples" # install examples
    pkgshare.install "unit"     # install unit tests
  end

  test do
    # run unit tests compiled with 'make check'
    if build.with? "check"
      Dir["#{pkgshare}/unit/*"].each { |f| system f if File.file?(f) && File.executable?(f) }
    end
  end
end

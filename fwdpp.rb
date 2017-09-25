class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.7.tar.gz"
  sha256 "e038462b0522f4b5aa135211222ce354df4c81a89122240b9eaacc72b62a0ceb"
  revision 1
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "0d85bdcc4dab387d590b9e25894d374c64d2d54d01846ce4b02d9178277eca17" => :high_sierra
    sha256 "b157496fc7a64f4b997fd8bd48c591a8f2060a64b0960d0b8ee82245c280cb67" => :sierra
    sha256 "add46b20f617f12c5d0746665ce503859dd2ac52d38417efd1e46d0ed9143143" => :el_capitan
    sha256 "43c0c9f501b9ae633172db3a16ead256f7ad567607ce356799d000e3d71ee175" => :x86_64_linux
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

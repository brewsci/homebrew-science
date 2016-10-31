class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.3.tar.gz"
  sha256 "95f6a7f37513c5e364943347029e5813e6a8c8688ac032e4284dd62483b891aa"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "273af7f150fd4b3d85cc67c3198e2457c6412b915989c5e605100e06800a63fb" => :sierra
    sha256 "85d4322c1197c4165fa215310aa4a7a79f13348ab3baffc12c847f3b89ecece5" => :el_capitan
    sha256 "72bd0409e2b8ef3f735330956f574c2a154fd0cd4516c611c3291e68855be966" => :yosemite
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  # build fails on mountain lion at configure stage when looking for libsequence
  # so restrict to mavericks and newer
  depends_on :macos => :mavericks

  depends_on "gsl"
  depends_on "libsequence"
  depends_on "boost" => :recommended

  def install
    ENV.O2
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

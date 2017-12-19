class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.7.tar.gz"
  sha256 "e038462b0522f4b5aa135211222ce354df4c81a89122240b9eaacc72b62a0ceb"
  revision 2
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest boost"

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

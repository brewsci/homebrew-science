class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.4.6.tar.gz"
  sha256 "ec4d4edee09824d19c23f35e5e9b4eac62ae79b62ece6cbb2c96656cd91b9bc5"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "415bf7780e809c2bddd4e849933863cfef5d3d1cefbecb18d6922aeebc1bba6f" => :el_capitan
    sha256 "cda19251b04cf73b7dc792b62a1cd18986c89ab6c84c6a98ac8d2ab5a502fe05" => :yosemite
    sha256 "28949e93e3bc60d7c72541c289653d30e7f7283987c2889f0a32fee5cfe28614" => :mavericks
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

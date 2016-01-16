class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.4.4.tar.gz"
  sha256 "6bdc32890d188075dff2502b29b2ebb6c5bbdfb673badf61354f1d66d994da03"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "5d66b2035b82a1cd1f1e3504218f376c0dc0e0aa53a69aea8df61d374b64b1ec" => :el_capitan
    sha256 "b95f0e3fdc54d10c7a8a8604274ad45f25d6a75306861270f05e3e34e43370e4" => :yosemite
    sha256 "9495a3cb5d6b6f3152faad964348b4b2fafef2b0a48d5eaf85190cc7a3fd8b3a" => :mavericks
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

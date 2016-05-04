class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.4.9.tar.gz"
  sha256 "bc318d1bd3a1e4b8fb2af8c6e5d416ccc191f52ef00b5a32c3391e047752c4ef"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "4116b0efd91c0ca1b31a33343c2b0e6bad73c21ac1532510acbb5b15daf545c0" => :el_capitan
    sha256 "85f73a08112f7f4a90479bead37e74d1e2b227c4241b0185ed2e0d11beb1cb07" => :yosemite
    sha256 "3c3d80ea4cc148bfdf2cb39dc596b271bfee8b8884036afd86af19c031cf25e1" => :mavericks
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

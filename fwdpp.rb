class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.0.tar.gz"
  sha256 "ee3ab255911c5d788a0388542865b4be109ec0f35b815368ac8758b9f572b26e"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "29ee48d206a7503c830547a5be122036806cfe28c52ae5eaa839b057198f9d09" => :el_capitan
    sha256 "45dbb68952879f05e7b39d64a10ffa95a3c601780b24d24e93b92f7f4784c0d4" => :yosemite
    sha256 "5813a10340ab006a0c86810e809ccdfc11bd6c8db006d528c9d3cbed395fae7a" => :mavericks
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

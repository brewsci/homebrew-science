class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.0.tar.gz"
  sha256 "ee3ab255911c5d788a0388542865b4be109ec0f35b815368ac8758b9f572b26e"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "e74eb0c7786ea05c641f94464df02c9e77551956e55ef9f4cc3074d2dd5a3326" => :el_capitan
    sha256 "4253862f4d9ea7b7005660cf9fd9b746898a29fa6a68ffa092ad7a6f0ad2aea1" => :yosemite
    sha256 "5ad08aadd33fe1d7c848498569b9dcee120e9f958284848232767ee19129dd0d" => :mavericks
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

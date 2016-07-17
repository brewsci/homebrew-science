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
    sha256 "e74eb0c7786ea05c641f94464df02c9e77551956e55ef9f4cc3074d2dd5a3326" => :el_capitan
    sha256 "4253862f4d9ea7b7005660cf9fd9b746898a29fa6a68ffa092ad7a6f0ad2aea1" => :yosemite
    sha256 "5ad08aadd33fe1d7c848498569b9dcee120e9f958284848232767ee19129dd0d" => :mavericks
    sha256 "e2f6b66524ca427accbebc40fdc79a68ce2b3503d430ff3621be5e1cabf35b8a" => :x86_64_linux
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

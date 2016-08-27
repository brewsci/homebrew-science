class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.2.tar.gz"
  sha256 "153f0b5b97854849615053a9cecf8408c0cf809f5508a576cef86b12197d708e"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "448f70e0f045bfb77e7ebe8d89935509b5e4b9e677c8d4f05404f2f9dd6e0696" => :el_capitan
    sha256 "d66625d6f617d5b30535f75d0c02273d25a7d79ba393396f8f09b555222ea94c" => :yosemite
    sha256 "99e736627840f266d6e4cd4f0052061e7c045bcbfc97c5340246ee64a6c995dd" => :mavericks
    sha256 "7449a508a0230cf8695d3c2e72dc7e6bbdc36559a6c1a6b7160bfcba2501761a" => :x86_64_linux
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

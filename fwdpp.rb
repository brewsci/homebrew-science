class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.4.tar.gz"
  sha256 "11e4592c764a6c07f83bc76e1c08197bc084570848d1919c09f5557e3600d705"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "7ff285d74ec97d4b6552c947ed9537fc765d0758f95790bc99a4de7eeb579d24" => :sierra
    sha256 "0533be2ae4d841baf4c6a5d20b40d1313b4323aa059c609009f70bf11488d29a" => :el_capitan
    sha256 "086056061adb332e0b45331c9dc5afb8ef1b4cc4186b9cad30eefa6fb88747f1" => :yosemite
    sha256 "2b7bb49d50a7e62a4ccd7956287541bece84776c88b5bccca6c28317e17b83ab" => :x86_64_linux
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

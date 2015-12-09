class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.4.3.tar.gz"
  sha256 "916a7f28a2a5b8622bae2680e9d0f5538efff4e33f4be15485d2b0454b9eff68"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "78f5a07d758d4e3de71e63c692ef81efc360b993f05a5069bbabd619bab7091d" => :el_capitan
    sha256 "182ab26496cb87595afeaaff663665acd8b9dfa7478bac006628f0bcf5b89a36" => :yosemite
    sha256 "f0fb97dc1d2846ce0bb14191c09200cbfa0cbc4160b367b8c70588e2d37c1d2d" => :mavericks
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

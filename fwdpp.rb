class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.2.tar.gz"
  sha256 "153f0b5b97854849615053a9cecf8408c0cf809f5508a576cef86b12197d708e"
  revision 1

  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "2b4865fcacdcc89e7736775badc99dd2559892e09742b8068fd90d468d30dc04" => :el_capitan
    sha256 "542a5bd2087d974f6c98cb851c2f66b5c9ad4761a7b6ce17f33cf21de39e70c0" => :yosemite
    sha256 "11c9a6b1101f05382059bd81f82e0f02fae561a61854b896898f4a04a4349b46" => :mavericks
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

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
    sha256 "c785a5999d4b0cc7bbf0a091434a1a57b4ecf82957313a3c4d77b7fa2431349a" => :el_capitan
    sha256 "89fb122a30f40da1ff691f337c55bf3536d5531df21b442658ed7056c488c14b" => :yosemite
    sha256 "9bf816a3d87dc0f6514bbd9747a32ae13bd6b91d4f02487cb53022657bad08c4" => :mavericks
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  # build fails on mountain lion at configure stage when looking for libsequence
  # so restrict to mavericks and newer
  depends_on macos: :mavericks

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

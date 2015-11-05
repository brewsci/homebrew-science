class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.4.1.tar.gz"
  sha256 "b5c57f2f484add213c52a2232933a37c31d0b51bc908c69f6a06042a54be1b70"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "cd50780f93dad1275e24650eb2eeaad61044422bded4ebf62d26a40b71af350f" => :el_capitan
    sha256 "558c05b7f22f632c458dc3800cd4b983d21f2e3b67ae6fd09eb72e7f6e3a576b" => :yosemite
    sha256 "f54f71b1c72d8d3f0df47420282f12b90638eae2bba15d3d09c13f11afe9cc29" => :mavericks
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

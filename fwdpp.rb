class Fwdpp < Formula
  desc "fwdpp is a C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.3.7.tar.gz"
  sha256 "fbc3afa48072ca1884488faad40658cba33357e9a83333c8665b6ce71bd3cc81"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "ad2b89fa050c4b2d4e7bb0d15e72de524d9f26b5cd34065776e55e03b8e97931" => :yosemite
    sha256 "7b4ec302576cd878143c006e2e10dd6e16eef5de2118ad332851869726aac8d8" => :mavericks
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

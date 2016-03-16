class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.4.7.tar.gz"
  sha256 "b97d633ba74f955541d87a54e887a43581c0fec41e3881eb05b11b9027c31cb8"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"

  bottle do
    cellar :any
    sha256 "45a480f7e34404f88b40cc7632e27d94dea2448feaa646eb28e5750f220902d0" => :el_capitan
    sha256 "5c881981b5bf4db81ef833a723155e8ff1999a12884ed1f2bd8c536556fc90a4" => :yosemite
    sha256 "af5d493bcfde8bc185bc8119ac72f58d144bf5bea31e4dd2d33e147552d5dade" => :mavericks
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

class Fwdpp < Formula
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.6.tar.gz"
  sha256 "f4a96868ca054364d636792ffb3bce760498b494778b83139bfb985b440df093"
  head "https://github.com/molpopgen/fwdpp.git"
  # doi "10.1534/genetics.114.165019"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "684650c0b572e16944f3666098e69e24e166121c1980f8f2bd30aa4164f245eb" => :sierra
    sha256 "35cd3374ad42a1a8c478633b93b587f77cadbfe0209be1d5591761d4b91fe60c" => :el_capitan
    sha256 "80a324580a44dd0c668ab838118c347f9ad992224d3e4aaabe08b7f699177b82" => :yosemite
    sha256 "806a50d0f71e49ab487fc4a4688a1e94a91a5ddd58f36e3b1d035eb8c6c7a33b" => :x86_64_linux
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  # build fails on Yosemite
  depends_on :macos => :el_capitan

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

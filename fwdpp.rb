class Fwdpp < Formula
  homepage "https://molpopgen.github.io/fwdpp/"
  # doi "10.1534/genetics.114.165019"

  url "https://github.com/molpopgen/fwdpp/archive/0.3.1.tar.gz"
  sha256 "7adfc7a17ba87c1ad53b091078db4830205e79a5bc86e8b924d9c1c75a0e3623"
  head "https://github.com/molpopgen/fwdpp.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "05fba0c74a1d839e83d0085b56f6dbd17a315eaf0d6f6d5e7bd5af4c6dfe1ea4" => :yosemite
    sha256 "7b2eadb4370421bfa375ee479ebf2b97a7fd4c7130bd46d364c156f47dcd4f23" => :mavericks
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
    share.install "examples" # install examples
    share.install "unit"     # install unit tests
  end

  test do
    # run unit tests compiled with 'make check'
    if build.with? "check"
      Dir["#{share}/unit/*"].each { |f| system f if File.file?(f) && File.executable?(f) }
    end
  end
end

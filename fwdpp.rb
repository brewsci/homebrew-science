class Fwdpp < Formula
  homepage "https://molpopgen.github.io/fwdpp/"
  # doi "10.1534/genetics.114.165019"

  url "https://github.com/molpopgen/fwdpp/archive/0.3.1.tar.gz"
  sha256 "7adfc7a17ba87c1ad53b091078db4830205e79a5bc86e8b924d9c1c75a0e3623"
  head "https://github.com/molpopgen/fwdpp.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "9d28e4961f85e18a1c2c705e2d5acd4d1a29288be5c7e83a906445fc65469dfb" => :yosemite
    sha256 "6dff09399729959b34aa3a047a8e0b00a701de13c8bdf2ed7d1aa2ee0740be65" => :mavericks
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

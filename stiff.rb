class Stiff < Formula
  homepage "https://www.astromatic.net/software/stiff"
  url "https://www.astromatic.net/download/stiff/stiff-2.4.0.tar.gz"
  sha256 "f4e85146c17fe8dcf160d12dc6df08bbd9212bb8444162b2e6ebf03f7513a992"

  bottle do
    sha1 "ca69fddd5decd31af464a0a625c1c893ccb34530" => :yosemite
    sha1 "b98b28d0614841fccd631d5c9062277577e720f0" => :mavericks
    sha1 "09cc0873ce0f60c5127129f1cb779bbd6bb4c90e" => :mountain_lion
  end

  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "libtiff"
  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    # We have no test data, so just verify we can load the program.
    system "#{bin}/stiff", "-v"
    system "#{bin}/stiff", "-h"
  end
end

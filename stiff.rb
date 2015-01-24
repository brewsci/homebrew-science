class Stiff < Formula
  homepage "https://www.astromatic.net/software/stiff"
  url "https://www.astromatic.net/download/stiff/stiff-2.4.0.tar.gz"
  sha256 "f4e85146c17fe8dcf160d12dc6df08bbd9212bb8444162b2e6ebf03f7513a992"

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

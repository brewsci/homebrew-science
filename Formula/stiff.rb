class Stiff < Formula
  homepage "https://www.astromatic.net/software/stiff"
  url "https://www.astromatic.net/download/stiff/stiff-2.4.0.tar.gz"
  sha256 "f4e85146c17fe8dcf160d12dc6df08bbd9212bb8444162b2e6ebf03f7513a992"

  bottle do
    sha256 "aab415dd0148fdaf0cffb79888351d7177f53c19a7f43ab13cbdf974fff0db68" => :yosemite
    sha256 "a56055248ff914d1b3fea510d23dac1d47c7d7eee3f8123e878c7a7a6f97b85a" => :mavericks
    sha256 "237a776dca0c927aa5d7d2e6c6be78d2c452fd305e6449daa3570858fe41985f" => :mountain_lion
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

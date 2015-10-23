class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.2.tar.gz"
  sha256 "481fe357cf755426fb8e25f4f890e827cce5de657a4e5044d4e31ce27bef1c8b"

  bottle do
    cellar :any
    sha1 "e33240bd4f007854cc524e63bb16632788e78d6e" => :yosemite
    sha1 "388f01432720ad17b31e6ce4d1c726346f785d22" => :mavericks
    sha1 "a77678d6d1af694167dad79bce2562985cf612e3" => :mountain_lion
  end

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    system "imhead 2>&1 | grep -q 'IMHEAD'"
  end
end

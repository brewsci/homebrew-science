require "formula"

class Wcstools < Formula
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.1.tar.gz"
  sha1 "05d97277fdfcabd40f926b0b7ac66b0f434497f0"

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

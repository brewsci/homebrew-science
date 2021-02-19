class Ds9 < Formula
  desc "Astronomical imaging and data visualization"
  homepage "http://ds9.si.edu/"
  url "http://ds9.si.edu/archive/source/ds9.7.3.2.tar.gz"
  version "7.3.2"
  sha256 "05d581780f41d02799777c5a2095ea6e74dc70bd80175c96babe241c23d0145f"
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, el_capitan: "40e75509fb3fb53f2d3a391f6b1df3971ce0878d2625a2680a053ec1e7ca3edd"
    sha256 cellar: :any_skip_relocation, yosemite:   "a35573fb5f27b6e914711f1d98e7d616ebc2e27242beece1341c2d9c2f0ebca8"
    sha256 cellar: :any_skip_relocation, mavericks:  "211226f72b21eef4059b09fba5072adca9fe1a3cc62e5f38730134a707edfd92"
  end

  depends_on "libx11"

  def install
    ENV.deparallelize
    # omit code signing as we do not have the signing identity
    inreplace "ds9/Makefile.unix", '$(CODESIGN) -s "SAOImage DS9" ds9', ""

    ln_s "make.darwinmavericks", "make.include"

    system "make"
    # ds9 requires the companion zip file to live in the same location as the binary
    bin.install "ds9/ds9", "ds9/ds9.zip"
  end

  test do
    system "ds9", "-analysis", "message", "'It works! Press OK to exit.'", "-exit"
  end
end

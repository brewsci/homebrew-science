require 'formula'

class Ds9 < Formula
  homepage "http://ds9.si.edu/"
  url "http://ds9.si.edu/archive/source/ds9.7.3.2.tar.gz"
  version "7.3.2"
  sha1 "0348b733923871ef1d36da653dd3fd90d33a4c20"

  depends_on :macos => :lion
  depends_on :x11

  def install
    ENV.deparallelize
    # omit code signing as we do not have the signing identity
    inreplace 'ds9/Makefile.unix', '$(CODESIGN) -s "SAOImage DS9" ds9', ''

    if MacOS.version == :lion
      ln_s "make.darwinlion", "make.include"
    elsif MacOS.version == :mountainlion
      ln_s "make.darwinmountainlion", "make.include"
    else
      ln_s "make.darwinmavericks", "make.include"
    end

    system "make"
    # ds9 requires the companion zip file to live in the same location as the binary
    bin.install 'ds9/ds9', 'ds9/ds9.zip'
  end

  test do
    system "ds9 -analysis message 'It works! Press OK to exit.' -exit"
  end
end

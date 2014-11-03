require "formula"

class Sextractor < Formula
  homepage "http://www.astromatic.net/software/sextractor"
  url "http://www.astromatic.net/download/sextractor/sextractor-2.19.5.tar.gz"
  sha1 "43a48391b90b915b1c256b68c29c2276bee8621d"

  depends_on "fftw"
  depends_on "autoconf" => :build

  option "without-check", "Disable build-time checking (not recommended); running check will take 5-10 minutes"


  # these patches collectively make the changes needed to compile with the Accelerate
  # framework for linear algebra routines.
  patch do
    # make macro file for autoconf to enable Accelerate lib
    url "https://gist.githubusercontent.com/mwcraig/ae66eadcd0f266e7138f/raw/f4625508784e75c7b3ce11d8a578589425533282/acx_accelerate.m4.diff"
    sha1 "3abc1e8ab3975911897958c21f32e9d89481dc4f"
  end
  patch do
    # Patch configure.ac to see new macro
    url "https://gist.githubusercontent.com/mwcraig/4f61431f177b6cc0085a/raw/bf4d29a7a51ccec1ef224006fd10ac260a31c37c/configure.ac.diff"
    sha1 "b92ec8997567aebfa0d9416d3c117d13c4c8337d"
  end
  patch do
    # change name/arguments of LAPACK functions from ATLAS to Accelerate, and add include file
    url "https://gist.githubusercontent.com/mwcraig/b423656698987b6bc492/raw/f23c4b50d972de4e7902fe3d4fa1363400a98f8f/pattern.c.diff"
    sha1 "70f4552f30e3fd5c010e124ff2115d7b7459c020"
  end

  def install
    system "autoconf"
    system "autoheader"
    system "./configure", "--prefix=#{prefix}", "--enable-accelerate"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

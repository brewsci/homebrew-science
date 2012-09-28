require "formula"

class Sextractor < Formula
  homepage "http://www.astromatic.net/software/sextractor"
  url "http://www.astromatic.net/download/sextractor/sextractor-2.8.6.tar.gz"
  sha1 "103ac2d51d9bae9fcbc5dda3031d82cd127f8250"

  depends_on "fftw"
  depends_on "autoconf" => :build

  option "without-check", "Disable build-time checking (not recommended); running check will take 5-10 minutes"

  def patches
    # these patches collectively make the changes needed to compile with the Accelerate
    # framework for linear algebra routines.
    {:p1 => [
      # patch the macro file for autoconf to test for functionality of Accelerate lib
      "https://gist.githubusercontent.com/mwcraig/9540830/raw/19a0284f9d02092b7159e1bae2cdcafdb9282ef1/acx_atlas.m4.diff",
      # lm.h patch
      "https://gist.githubusercontent.com/mwcraig/9540846/raw/8949f238c911aa8e6b4553d7fcc9f0c2fcbb35d0/lm.h.diff",
      # Add definition of pre-processor macro and modify GEMM call to match Accelerate
      "https://gist.githubusercontent.com/mwcraig/9540872/raw/2069659ba5699f065044a2acbbd4538f96a28533/misc_core.c.diff",
      # include BLAS header file
      "https://gist.githubusercontent.com/mwcraig/9540885/raw/5372b5b7c4a716dcb5c1eedc473a82d3a07694aa/misc.c.diff",
      # set BLAS prefix/suffix for Accelerate
      "https://gist.githubusercontent.com/mwcraig/9540929/raw/af0485c4a4f83a5f49c679eafd622adbf4a90a3e/misc.h.diff",
      # change name/arguments of LAPACK functions from ATLAS to Accelerate, and add include file
      "https://gist.githubusercontent.com/mwcraig/9540907/raw/92e8af0e68cac2b1928545a9a1222752cf8440b1/pattern.c.diff"]}
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--without-atlas"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

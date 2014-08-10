require "formula"

class Sextractor < Formula
  homepage "http://www.astromatic.net/software/sextractor"
  url "http://www.astromatic.net/download/sextractor/sextractor-2.8.6.tar.gz"
  sha1 "103ac2d51d9bae9fcbc5dda3031d82cd127f8250"

  depends_on "fftw"
  depends_on "autoconf" => :build

  option "without-check", "Disable build-time checking (not recommended); running check will take 5-10 minutes"


  # these patches collectively make the changes needed to compile with the Accelerate
  # framework for linear algebra routines.
  patch do
    # patch the macro file for autoconf to test for functionality of Accelerate lib
    url "https://gist.githubusercontent.com/mwcraig/9540830/raw/19a0284f9d02092b7159e1bae2cdcafdb9282ef1/acx_atlas.m4.diff"
    sha1 "1a36d08776d646630645058dadebad1edb69bff0"
  end
  patch do
    # lm.h patch
    url "https://gist.githubusercontent.com/mwcraig/9540846/raw/8949f238c911aa8e6b4553d7fcc9f0c2fcbb35d0/lm.h.diff"
    sha1 "23792d85ef20f1f2cbefd1fface64f420ba2818c"
  end
  patch do
    # Add definition of pre-processor macro and modify GEMM call to match Accelerate
    url "https://gist.githubusercontent.com/mwcraig/9540872/raw/2069659ba5699f065044a2acbbd4538f96a28533/misc_core.c.diff"
    sha1 "fa806cd01acc3924c29b3e9423c698ac1bc82901"
  end
  patch do
    # include BLAS header file
    url "https://gist.githubusercontent.com/mwcraig/9540885/raw/5372b5b7c4a716dcb5c1eedc473a82d3a07694aa/misc.c.diff"
    sha1 "ee8317af99ab1678b0e6f84592099bec3269b391"
  end
  patch do
    # set BLAS prefix/suffix for Accelerate
    url "https://gist.githubusercontent.com/mwcraig/9540929/raw/af0485c4a4f83a5f49c679eafd622adbf4a90a3e/misc.h.diff"
    sha1 "dfc3351201503d358a4ab8f42bf42a7fc56c70db"
  end
  patch do
    # change name/arguments of LAPACK functions from ATLAS to Accelerate, and add include file
    url "https://gist.githubusercontent.com/mwcraig/9540907/raw/92e8af0e68cac2b1928545a9a1222752cf8440b1/pattern.c.diff"
    sha1 "1cd2df08d6b36fa6a9c6751a46f4ce3893486c38"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--without-atlas"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

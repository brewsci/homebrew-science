class Sextractor < Formula
  homepage "https://www.astromatic.net/software/sextractor"
  url "https://www.astromatic.net/download/sextractor/sextractor-2.19.5.tar.gz"
  sha256 "2a880e018585f905300d5919ab454b18640a5bef13deb5c4f03111ac4710b2c5"

  option "without-check", "Disable build-time checking (not recommended); running check will take 5-10 minutes"

  depends_on "fftw"
  depends_on "autoconf" => :build

  # these patches collectively make the changes needed to compile with the Accelerate
  # framework for linear algebra routines.
  patch do
    # make macro file for autoconf to enable Accelerate lib
    url "https://gist.githubusercontent.com/mwcraig/ae66eadcd0f266e7138f/raw/f4625508784e75c7b3ce11d8a578589425533282/acx_accelerate.m4.diff"
    sha256 "5d9dcad73169b527903c67f2bcf415019f0a01a90f8c2185c6a4482f587279e3"
  end
  patch do
    # Patch configure.ac to see new macro
    url "https://gist.githubusercontent.com/mwcraig/4f61431f177b6cc0085a/raw/bf4d29a7a51ccec1ef224006fd10ac260a31c37c/configure.ac.diff"
    sha256 "a7ef31a1f624e4b39ede543dc204b9a75bcb02a8f7553b5afdb146748521b6ad"
  end
  patch do
    # change name/arguments of LAPACK functions from ATLAS to Accelerate, and add include file
    url "https://gist.githubusercontent.com/mwcraig/b423656698987b6bc492/raw/f23c4b50d972de4e7902fe3d4fa1363400a98f8f/pattern.c.diff"
    sha256 "6c113df914b411cc1d186e03f8aee4ab46deca434f2d31dd94cf503e4d45fb4f"
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

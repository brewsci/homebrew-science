require 'formula'

class Veclibfort < Formula
  homepage 'https://github.com/mcg1969/vecLibFort'
  url 'https://github.com/mcg1969/vecLibFort/archive/0.3.0.tar.gz'
  sha1 '5a9d1bb5db1df5bc5fc0c9cfd241ab35e1a99bd6'
  head 'https://github.com/mcg1969/vecLibFort.git'

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "make", "all"
    system "make", "check" if build.with? "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    caveats = <<-EOS.undent
      Installs the following files:
        * libvecLibFort.a: static library; link with -framework vecLib
        * libvecLibFort.dylib: dynamic library; *replaces* -framework vecLib
        * libvecLibFortI.dylib: preload (interpose) library.
      Please see the home page for usage details.
    EOS
  end
end

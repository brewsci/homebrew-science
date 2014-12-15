require 'formula'

class Veclibfort < Formula
  homepage 'https://github.com/mcg1969/vecLibFort'
  url 'https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz'
  sha1 'fee75b043a05f1dc7ec6649cbab73e23a71a9471'
  head 'https://github.com/mcg1969/vecLibFort.git'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "544e4056a277fff11f05ced8eb318047710054ac" => :yosemite
    sha1 "602c9fe5c6c8800d40c12e8d4b601314509f6135" => :mavericks
    sha1 "4367a36855936b60ee3d9c5baa2ca8e949dfb630" => :mountain_lion
  end

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

class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  head "https://github.com/mcg1969/vecLibFort.git"
  revision 3

  bottle do
    cellar :any
    sha256 "35872b8c1c96cd85647519ffbaaf7e4e5601c096dc6befbfcbe9c3ed60a768cc" => :sierra
    sha256 "065dfb03b655a4d6b5db5014d98ddcbbdd692faafe8e5e3d0a3fa16eb892b7a0" => :el_capitan
    sha256 "2f260ba95aa1d80b7fb50dcae7de87e6e662c173e0a28a8306c45ea8c716d0bd" => :yosemite
    sha256 "34fc5eda407df36135633d678adc813890d291f77132118ff98756944edc0819" => :mavericks
  end

  depends_on :fortran

  def install
    odie "Use openblas instead of veclibfort on Linux" if OS.linux?
    ENV.m64 if MacOS.prefer_64_bit?
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "tester.f90"
  end

  def caveats; <<-EOS.undent
      Installs the following files:
        * libvecLibFort.a: static library; link with -framework vecLib
        * libvecLibFort.dylib: dynamic library; *replaces* -framework vecLib
        * libvecLibFortI.dylib: preload (interpose) library.
      Please see the home page for usage details.
    EOS
  end

  test do
    ENV.fortran
    cd testpath do
      system ENV["FC"], "-o", "tester", "-O", pkgshare/"tester.f90", "-L#{lib}", "-lvecLibFort"
      system "./tester"
    end
  end
end

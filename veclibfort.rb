class MacOSRequirement < Requirement
  fatal true
  satisfy(build_env: false) { OS.mac? }
  def message
    "macOS is required."
  end
end

class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  head "https://github.com/mcg1969/vecLibFort.git"
  revision 4

  bottle do
    cellar :any
    sha256 "3e787cb188aa824e2541c58ece4e8c02c61b0e6025646765495392ea5019fa8d" => :sierra
    sha256 "9cf0fa95441309c52caae5886182c244cc05449c08cfa102decfc1c63d266e42" => :el_capitan
    sha256 "e4a6cb9d134ab7d182a8eaf7dec32df3d31ff42afe3e30a7c12bd4335c6c897f" => :yosemite
  end

  depends_on MacOSRequirement
  depends_on :fortran

  def install
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

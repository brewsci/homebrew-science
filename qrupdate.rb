require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'
  revision 2

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "c06f83599521ac084727982e284a571331974e634a00168771dd48984937f2d7" => :yosemite
    sha256 "e5157b5d52d77c07e5e832522d983a9436a55b42ee0309046ad235e6a2f0ee80" => :mavericks
    sha256 "2efd4bdff479a3eabbe853ad988fa8396b7fe38fa85dccdca46b9cbd9e98be87" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without? "openblas" and OS.mac?

  def install
    ENV.j1
    if build.with? "openblas"
      blas = "-L#{Formula['openblas'].opt_lib} -lopenblas"
      lapack = blas
    else
      blas = (OS.mac?) ? "-L#{Formula['veclibfort'].opt_lib} -lveclibfort" : "-lblas"
      lapack = (OS.mac?) ? blas : "-llapack"
    end
    make_args = ["FC=#{ENV.fc}", "FFLAGS=#{ENV.fcflags}",
                 "BLAS=#{blas}", "LAPACK=#{lapack}"]
    inreplace 'src/Makefile' do |s|
      s.gsub! 'install -D', 'install'
    end
    lib.mkpath
    system "make", "lib", "solib", *make_args
    system "make", "test", *make_args if build.with? "check"
    rm "INSTALL"  # Somehow this confuses "make install".
    system "make", "install", "PREFIX=#{prefix}"
  end
end

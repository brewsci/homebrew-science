require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'
  revision 3

  bottle do
    cellar :any
    sha256 "87f5f73b4a539d3b828d88c1349364c19bb8d32f07bc9f4d91f7a6573708ee66" => :el_capitan
    sha256 "8ab65a104134c127e18d67b81e1daeb508405b008f15963376114f9a0b424f7e" => :yosemite
    sha256 "564ac58d4c00489534f6890430d8dc6b5b15e5aaa67fb0101bedc4002d4665d5" => :mavericks
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
      blas = (OS.mac?) ? "-L#{Formula['veclibfort'].opt_lib} -lvecLibFort" : "-lblas"
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

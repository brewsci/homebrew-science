require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'
  revision 1

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without? "openblas"

  def install
    ENV.j1
    blas = (build.with? "openblas") ? "openblas" : "vecLibFort"
    blas = "-L#{Formula["#{blas}"].opt_lib} -l#{blas}"
    make_args = ["FC=#{ENV.fc}", "FFLAGS=#{ENV.fcflags}",
                 "BLAS=#{blas}", "LAPACK=#{blas}"]
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

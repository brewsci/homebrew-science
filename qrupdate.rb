require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "8416cb9a1d5aef63ef8cc4711511cc43c75231c6" => :yosemite
    sha1 "240df8f3a3650dbdd41b3808db5aad68975629d2" => :mavericks
    sha1 "07b17148c0f6a32df0ddaa169a96e54b41e44981" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without? "openblas" and OS.mac?

  def install
    ENV.j1
    if build.with? "openblas"
      blas = "-L#{Formula['openblas'].opt_lib} -lopenblas"
    else
      blas = (OS.mac?) ? "-L#{Formula['veclibfort'].opt_lib} -lveclibfort" : %w(-lblas -llapack)
    end
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

require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 2
    sha1 "6cf2f84c29df94e4ddd137fb75b2a36a30bc4ea7" => :yosemite
    sha1 "c2b46258201e5218e187fd65b70395ae06b8113c" => :mavericks
    sha1 "03888309204008476b2e8fda517f1ee8b5a5ba4f" => :mountain_lion
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

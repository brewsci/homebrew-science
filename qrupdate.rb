class Qrupdate < Formula
  homepage "http://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 4

  bottle do
    cellar :any
    sha256 "41e44bd439bf76efd0c32f87c8968efa8143d9ebe71e96c4345fac1847f0d0ba" => :el_capitan
    sha256 "ad4754939869974e4147018e4dcc7f83b95727d83244d5c3acab732b6e92e0ae" => :yosemite
    sha256 "c1067adb88710e0abc4677effbbf0aaca08a8eaf657fc25239c6a274aece9c6e" => :mavericks
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  def install
    ENV.j1
    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      lapack = blas
    else
      blas = OS.mac? ? "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort" : "-lblas"
      lapack = OS.mac? ? blas : "-llapack"
    end
    make_args = ["FC=#{ENV.fc}", "FFLAGS=#{ENV.fcflags}",
                 "BLAS=#{blas}", "LAPACK=#{lapack}"]
    inreplace "src/Makefile", "install -D", "install"
    lib.mkpath
    system "make", "lib", "solib", *make_args
    system "make", "test", *make_args if build.with? "check"
    rm "INSTALL" # Somehow this confuses "make install".
    system "make", "install", "PREFIX=#{prefix}"
  end
end

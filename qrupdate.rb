class Qrupdate < Formula
  homepage "http://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 4

  bottle do
    cellar :any
    rebuild 1
    sha256 "44e581580a31b504fb7ce816dab11473e7644b13cede5661e2a6212d322d0a19" => :sierra
    sha256 "7bc6c8d7c20f7080a70f16bfa7a728fdcdc75dd8fcaa225d8a9205aa7a0488d1" => :el_capitan
    sha256 "197b6d2237bd187a178ab7140f6b6e1629b1cabdf6a2f74978b46b5a5874d58c" => :yosemite
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)
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

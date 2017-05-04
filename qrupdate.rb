class Qrupdate < Formula
  homepage "http://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 5

  bottle do
    cellar :any
    sha256 "99c8dbcb91c73e66d2df381c33e02b18186c5ed2879ae53bb9b3295abfd5f7ac" => :sierra
    sha256 "85aa980364e2554129866ff522d6a183c94c5dae6541756b7d210e7ae2e4c8ee" => :el_capitan
    sha256 "e4d535b72e716f0816b6a926f0e0e207f2f0e8e17082856c978544b47d99802e" => :yosemite
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  def install
    ENV.deparallelize
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

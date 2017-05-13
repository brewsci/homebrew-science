class Qrupdate < Formula
  homepage "https://sourceforge.net/projects/qrupdate/"
  url "https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz"
  sha256 "e2a1c711dc8ebc418e21195833814cb2f84b878b90a2774365f0166402308e08"
  revision 6

  bottle do
    cellar :any
    sha256 "c42acd4c8d6640cdd61ec1f47206e6719959f48681c2ca5d5942f08bbd77b42e" => :sierra
    sha256 "a1fd06aac4c8f66ee0df2c4619bc9d40b01b5b70727a927be89352c5930f0413" => :el_capitan
    sha256 "73dd0ff160d2004d5fd37e420cead05650a5b2e3004d3133af6f2d16b9a1dd89" => :yosemite
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

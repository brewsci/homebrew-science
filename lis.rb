class Lis < Formula
  desc "Library of Iterative Solvers for Linear Systems"
  homepage "http://www.ssisc.org/lis"
  url "http://www.ssisc.org/lis/dl/lis-1.4.34.tar.gz"
  sha256 "e25fb5ef0c52fa0c66efab626da7d1a4b4082776173ffce632a034ab73a4d292"
  revision 4

  bottle do
    cellar :any
    sha256 "bb451fc407949d90b2bc87bdf23285c9f8137d1a8711d163b7fda0079717c9f3" => :sierra
    sha256 "f710200b217fb5d19a2070733df3395228c1da4c732cf1327b80b58357cd17df" => :el_capitan
    sha256 "b188ef17d4204081f7579578a7197c5b138791de355a094e79612dab4bb92adc" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"
  option "with-saamg",    "build SA-AMG preconditioner"
  option "with-quad",     "enable quadruple precision operations"

  deprecated_option "without-check" => "without-test"

  depends_on :fortran => :recommended
  depends_on :mpi => [:cc, :cxx, :f77, :f90, :recommended]

  def install
    ENV.deparallelize

    args = %W[--prefix=#{prefix} --disable-dependency-tracking --enable-shared]
    args << "--enable-fortran" if build.with? :fortran
    args << "--enable-mpi"     if build.with? :mpi
    args << "--enable-omp" unless ENV.compiler == :clang
    args << "--enable-saamg"   if build.with? "saamg"
    args << "--enable-quad"    if build.with? "quad"

    # Put examples in pkgshare
    inreplace "test/Makefile.in", "share/examples/lis", "share/lis/examples"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{pkgshare}/examples/test.sh"
  end
end

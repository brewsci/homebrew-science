class Lis < Formula
  desc "Library of Iterative Solvers for Linear Systems"
  homepage "http://www.ssisc.org/lis"
  url "http://www.ssisc.org/lis/dl/lis-2.0.6.zip"
  sha256 "b9b17242c8dc0c7ef60a1e8053aedd5f7a04cc534634b0ae08551a0d59639ef9"

  bottle do
    cellar :any
    sha256 "fd673e526a8b0d09aaf1ebaac24225126169fca6b573043743378ecbf4f474c3" => :high_sierra
    sha256 "5270c7b46956bbefcf51b34889f8c5f591a9961fc5d20c54b122ebfdbaec869f" => :sierra
    sha256 "26b812f8b22b005b210322b456a17dcff9ef025d896759fda41d36358ba925b8" => :el_capitan
    sha256 "a9d50a8973f4f78ad1b7b2fa9ed7f3e078727e4c71ede0333eb134db5e414059" => :x86_64_linux
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

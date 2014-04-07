require "formula"

class Lis < Formula
  homepage "http://www.ssisc.org/lis"
  url "http://www.ssisc.org/lis/dl/lis-1.4.34.tar.gz"
  sha1 "60b08e4428c8f02e545b07817efef212dd2fb9df"

  option "without-check", "Skip build-time checks (not recommended)"
  option "with-saamg",    "build SA-AMG preconditioner"
  option "with-quad",     "enable quadruple precision operations"

  depends_on :fortran => :recommended
  depends_on :mpi => [:cc, :cxx, :f77, :f90, :recommended]

  def install
    ENV.deparallelize

    args = %W[ --prefix=#{prefix} --disable-dependency-tracking --enable-shared]
    args << "--enable-fortran" if build.with? :fortran
    args << "--enable-mpi"     if build.with? :mpi
    args << "--enable-omp" unless ENV.compiler == :clang
    args << "--enable-saamg"   if build.with? "saamg"
    args << "--enable-quad"    if build.with? "quad"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

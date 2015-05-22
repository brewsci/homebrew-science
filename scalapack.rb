class Scalapack < Formula
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha1 "ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a"
  head "https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk", :using => :svn
  revision 2

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "3a78fbd2b569d877708063fda6cefdedd5192bbf45f0417aa9334d041c77907c" => :yosemite
    sha256 "9fdb93a68b820d1b0ebaeb76dcbabe8de30d419ba2bf5c3a82dc2b5a6261841e" => :mavericks
    sha256 "19474cdf467f0bf78797d6a20edb59d4bb2ecf12c78cb510a3916c68a2a246d9" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :mpi => [:cc, :f90]
  depends_on "cmake" => :build
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on :fortran

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON"

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      lapack = blas
    else
      blas = (OS.mac?) ? "-L#{Formula["veclibfort"].opt_lib} -lveclibfort" : "-lblas"
      lapack = (OS.mac?) ? blas : "-llapack"
    end
    args += ["-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{lapack}"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end
end

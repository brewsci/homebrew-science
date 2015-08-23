class Scalapack < Formula
  desc "library of high-performance linear algebra routines for parallel distributed memory machines"
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha256 "0c74aeae690fe5ee4db7926f49c5d0bb69ce09eea75beb915e00bba07530395c"
  head "https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk", :using => :svn
  revision 3

  bottle do
    cellar :any
    sha256 "993d929b85d33adf35d1685ed20dbb86f4f68905d699eabd3e3902477db4e13b" => :yosemite
    sha256 "551a8f434451d019cf275c7ebcfad967a6180d5d414e2e68ddd7e42a94d64080" => :mavericks
    sha256 "fa76bb69b2963a04748e62dc20b84037f6dfabce104ea9850785bd40d88f0ad8" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :mpi => [:cc, :f90]
  depends_on "cmake" => :build
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on :fortran

  def install
    args = std_cmake_args
    # until the bug in pdlamch() of Scalapack is fixed
    # http://icl.cs.utk.edu/lapack-forum/viewtopic.php?f=13&t=4676&p=11434#p11434
    # avoid building shared libraries, as this could lead to SEGV in user's executables.
    # Namely, scalapack library will be infront of lapack library in the list of dynamic libraries
    # and thus if the user program or any third-party-library calls pdlamch(),
    # it will be found in scalapack instead of lapack, which will result in SEGV.
    # Arpack is a good example, which does not depend on Scalapack in any way, but calls
    # internally pdlamch(). Thus combining both MUMPS, which uses Scalapack
    # and Arpack in a single program leads to SEGV.
    # args << "-DBUILD_SHARED_LIBS=ON"

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

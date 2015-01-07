require 'formula'

class Scalapack < Formula
  homepage 'http://www.netlib.org/scalapack/'
  url 'http://www.netlib.org/scalapack/scalapack-2.0.2.tgz'
  sha1 'ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a'
  head 'https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk', :using => :svn
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 2
    sha1 "bae037302eabbea385e6cbc22d125a123b2c08a7" => :yosemite
    sha1 "934fb738c7bbd4e584533085982f2a61e3d13446" => :mavericks
    sha1 "8dc227f7b7f55f0b0c3d97d82a718db0447db853" => :mountain_lion
  end

  option 'with-shared-libs', 'Build shared libs (some tests may fail)'
  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on :mpi => [:cc, :f90]
  depends_on 'cmake' => :build
  depends_on 'openblas' => :optional
  depends_on 'veclibfort' if build.without? 'openblas' and OS.mac?
  depends_on :fortran

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared-libs"

    if build.with? "openblas"
      blas = "-L#{Formula['openblas'].opt_lib} -lopenblas"
      lapack = blas
    else
      blas = (OS.mac?) ? "-L#{Formula['veclibfort'].opt_lib} -lveclibfort" : "-lblas"
      lapack = (OS.mac?) ? blas : "-llapack"
    end
    args += ["-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{lapack}"]

    mkdir "build" do
      system 'cmake', '..', *args
      system 'make all'
      system 'make test' if build.with? 'check'
      system 'make install'
    end
  end
end

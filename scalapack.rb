require 'formula'

class Scalapack < Formula
  homepage 'http://www.netlib.org/scalapack/'
  url 'http://www.netlib.org/scalapack/scalapack-2.0.2.tgz'
  sha1 'ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a'
  head 'https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk', :using => :svn

  option 'with-shared-libs', 'Build shared libs (some tests may fail)'
  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on :mpi => [:cc, :f90]
  depends_on 'cmake' => :build
  depends_on 'openblas' => :optional
  depends_on 'dotwrp' if build.without? 'openblas'
  depends_on :fortran

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared-libs"
    blaslib = (build.with? "openblas") ? "-L#{Formula['openblas'].lib} -lopenblas" : "-ldotwrp -Wl,-framework -Wl,Accelerate"
    args += ["-DBLAS_LIBRARIES=#{blaslib}", "-DLAPACK_LIBRARIES=#{blaslib}"]

    mkdir "build" do
      system 'cmake', '..', *args
      system 'make all'
      system 'make test' unless build.without? 'check'
      system 'make install'
    end
  end
end

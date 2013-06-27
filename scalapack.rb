require 'formula'

class Scalapack < Formula
  homepage 'http://www.netlib.org/scalapack/'
  url 'http://www.netlib.org/scalapack/scalapack-2.0.2.tgz'
  sha1 'ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a'

  option 'test', 'Verify the build with make test'

  depends_on :mpi => [:cc, :f90]
  depends_on 'cmake' => :build
  depends_on 'openblas' => :recommended
  depends_on 'dotwrp' if build.without? 'openblas'
  depends_on :fortran

  def install
    if build.with? 'openblas'
      args = std_cmake_args + [
        '-DBLAS_LIBRARIES=-lopenblas',
        '-DLAPACK_LIBRARIES=-lopenblas',
      ]
    else
      args = std_cmake_args + [
        '-DBLAS_LIBRARIES=-ldotwrp -Wl,-framework -Wl,Accelerate',
        '-DLAPACK_LIBRARIES=-ldotwrp -Wl,-framework -Wl,Accelerate',
      ]
    end

    mkdir "build" do
      system 'cmake', '..', *args
      system 'make all'
      system 'make test' if build.include? 'test'
      system 'make install'
    end
  end
end

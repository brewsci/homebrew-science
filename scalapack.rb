require 'formula'

class Scalapack < Formula
  homepage 'http://www.netlib.org/scalapack/'
  url 'http://www.netlib.org/scalapack/scalapack-2.0.2.tgz'
  sha1 'ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a'
  head 'https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk', :using => :svn
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 1
    sha1 "b7158d99b757ecf7b98f1d2a75b0fc0e50e8a607" => :yosemite
    sha1 "2d6749fcb108203e3f7fd74817785427be5faa11" => :mavericks
    sha1 "a57ab6a187f557ca96822c59014f905d884c8cc6" => :mountain_lion
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
    else
      blas = (OS.mac?) ? "-L#{Formula['veclibfort'].opt_lib} -lveclibfort" : %w(-lblas -llapack)
    end
    args += ["-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{blas}"]

    mkdir "build" do
      system 'cmake', '..', *args
      system 'make all'
      system 'make test' if build.with? 'check'
      system 'make install'
    end
  end
end

require 'formula'

class Scalapack < Formula
  homepage 'http://www.netlib.org/scalapack/'
  url 'http://www.netlib.org/scalapack/scalapack-2.0.2.tgz'
  sha1 'ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a'
  head 'https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk', :using => :svn
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "f93023fc4796abf28a9f4a9c79551569dbdf31e2" => :yosemite
    sha1 "94fdfa3445c1fc301f8649478aea02576d194865" => :mavericks
    sha1 "82ab5e50ba36891716c8c9fe2605082fcdc3dc78" => :mountain_lion
  end

  option 'with-shared-libs', 'Build shared libs (some tests may fail)'
  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on :mpi => [:cc, :f90]
  depends_on 'cmake' => :build
  depends_on 'openblas' => :optional
  depends_on 'veclibfort' if build.without? 'openblas'
  depends_on :fortran

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared-libs"
    blas = (build.with? "openblas") ? "openblas" : "vecLibFort"
    blas = "-L#{Formula["#{blas}"].opt_lib} -l#{blas}"
    args += ["-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{blas}"]

    mkdir "build" do
      system 'cmake', '..', *args
      system 'make all'
      system 'make test' if build.with? 'check'
      system 'make install'
    end
  end
end

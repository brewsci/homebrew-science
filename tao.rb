require 'formula'

class Tao < Formula
  homepage 'http://www.mcs.anl.gov/research/projects/tao'
  url 'http://www.mcs.anl.gov/research/projects/tao/download/tao-2.2.0.tar.gz'
  sha1 'ddd0b65ce568692527bc2de8e75cca5c10b1e749'
  version '2.2'

  depends_on 'petsc' => :build

  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on :fortran
  env :std  # Tests do not pass without this...

  def install
    ENV.deparallelize
    ENV['TAO_DIR'] = Dir.getwd
    ENV['PETSC_DIR'] = Formula.factory('petsc').prefix
    # Contrary to the TAO documentation, it's important to leave PETSC_ARCH undefined.
    # This is because PETSc wasn't installed to $(brew --prefix petsc)/$PETSC_ARCH.
    ENV['PETSC_ARCH'] = ''
    system "make all"
    system "make tao_testexamples"
    system "make tao_testfortran"
    ohai 'Test results are in ~/Library/Logs/Homebrew/tao. Please check them.'

    petsc_arch = 'arch-darwin-c-opt'
    (prefix + petsc_arch).install 'lib'  # Necessary for software that relies on TAO.

    # libtao does not have the appropriate install name.
    # This should be fixed upstream in future releases.
    system "install_name_tool -id #{prefix}/#{petsc_arch}/lib/libtao.dylib #{prefix}/#{petsc_arch}/lib/libtao.dylib"

    include.install Dir['include/*']
    doc.install 'docs'
    prefix.install 'conf'
  end
end

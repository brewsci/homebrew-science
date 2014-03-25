require 'formula'

class TmvCpp < Formula
  homepage 'http://code.google.com/p/tmv-cpp/'
  url 'https://googledrive.com/host/0B6hIz9tCW5iZdEcybFNjRHFmOEE/tmv0.72.tar.gz'
  sha1 '0c9737f01a55a46506b312de9bd136871e2a8deb'
  head 'http://tmv-cpp.googlecode.com/svn/trunk'

  option 'without-check', 'Do not build tests (not recommended)'
  option 'with-full-check', 'Go through all tests (time consuming)'
  depends_on 'scons' => :build

  def install
    args = ["CXX=#{ENV['CXX']}", "PREFIX=#{prefix}"]
    args += %w[INST_FLOAT=true INST_DOUBLE=true INST_LONGDOUBLE=true
               INST_INT=true SHARED=true TEST_FLOAT=true TEST_DOUBLE=true
               TEST_INT=true TEST_LONGDOUBLE=true
               WITH_BLAS=true WITH_LAPACK=true]
    args << "XTEST=1111111" if build.with? 'full-check'
    args << "WITH_OPENMP=false" if ENV.compiler == :clang

    scons *args
    scons "test" if build.with? "check"
    scons "examples"
    scons "install"

    # dylibs don't have the correct install name.
    %w[libtmv.0.dylib libtmv_symband.0.dylib].each do |libname|
      system "install_name_tool -id #{lib}/#{libname} #{lib}/#{libname}"
    end

    (share / "tmv/tests").install Dir["test/tmvtest*"] if build.with? "check"
    (share / "tmv/examples").install Dir["examples/*[^\.o]"]
  end

  def test
    Dir[share / 'tmv/tests/tmvtest*'].each do |testcase|
      system testcase
    end
  end
end

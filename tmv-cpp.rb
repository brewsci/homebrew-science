require 'formula'

class TmvCpp < Formula
  homepage 'http://code.google.com/p/tmv-cpp/'
  url 'https://tmv-cpp.googlecode.com/files/tmv0.71.tar.gz'
  sha1 'd407748ff4f6a0689edca006b070ff883ec59bbe'
  head 'http://tmv-cpp.googlecode.com/svn/tags/v0.71'

  option 'without-check', 'Do not build tests (not recommended)'
  option 'with-full-check', 'Go through all tests (time consuming)'
  depends_on 'scons' => :build

  # Fix a bug with Xcode 5.1. Remove when upgrading to v0.72
  # See https://code.google.com/p/tmv-cpp/issues/detail?id=9
  patch :p0 do
    url "https://tmv-cpp.googlecode.com/issues/attachment?aid=90002000&name=issue9.patch&token=Nn4yfV6CoV3nVsQNNzRfgp578V8%3A1394851189991"
    sha1 "b45e55cafdb20db16ad8f0873e77838a258fa980"
  end

  def install
    args = ["CXX=#{ENV['CXX']}", "PREFIX=#{prefix}"]
    # Add TEST_LONGDOUBLE=true to args when upgrading to v0.72
    # See https://code.google.com/p/tmv-cpp/issues/detail?id=8
    args += %w[INST_FLOAT=true INST_DOUBLE=true INST_LONGDOUBLE=true
               INST_INT=true SHARED=true TEST_FLOAT=true TEST_DOUBLE=true
               TEST_INT=true WITH_BLAS=true WITH_LAPACK=true]
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

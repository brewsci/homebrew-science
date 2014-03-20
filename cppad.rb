require 'formula'

class Cppad < Formula
  homepage 'http://www.coin-or.org/CppAD'
  url 'http://www.coin-or.org/download/source/CppAD/cppad-20140000.0.epl.tgz'
  version '20140000'
  sha1 '27ecae20785c95ac5af0f285b54be292aad75008'
  head 'https://projects.coin-or.org/svn/CppAD/trunk', :using => :svn

  # Only one of --with-boost, --with-eigen and --with-std should be given.
  depends_on 'boost' => :optional
  depends_on 'eigen' => :optional
  depends_on 'adol-c' => :optional
  option 'with-std', 'Use std test vector'
  option 'without-check', 'Skip comprehensive tests (not recommended)'

  depends_on 'cmake' => :build

  fails_with :gcc do
    build 5658
    cause <<-EOS.undent
      A bug in complex division causes failure of certain tests.
      See http://list.coin-or.org/pipermail/cppad/2013q1/000297.html
      EOS
  end

  def install
    if ENV.compiler == :clang
      opoo 'OpenMP support will not be enabled. Use --use-gcc if you require OpenMP.'
    end

    cmake_args = ["-Dcmake_install_prefix=#{prefix}", "-Dcppad_documentation=YES"]
    cppad_testvector = 'cppad'
    if build.with? 'boost'
      cppad_testvector = 'boost'
    elsif build.with? 'eigen'
      cppad_testvector = 'eigen'
      cmake_args << "-Deigen_prefix=#{Formula["eigen"].prefix}"
      cmake_args << "-Dcppad_cxx_flags=-I#{Formula["eigen"].include}/eigen3"
    elsif build.with? 'std'
      cppad_testvector = 'std'
    end
    cmake_args << "-Dcppad_testvector=#{cppad_testvector}"
    cmake_args << "-Dadolc_prefix=#{Formula["adol-c"].prefix}" if build.with? 'adol-c'

    mkdir 'build' do
      system "cmake", "..", *cmake_args
      system 'make check' if build.with? 'check'
      system 'make install'
    end
  end
end

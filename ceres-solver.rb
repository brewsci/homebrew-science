require 'formula'

class CeresSolver < Formula
  homepage 'http://code.google.com/p/ceres-solver/'
  url 'https://ceres-solver.googlecode.com/files/ceres-solver-1.8.0.tar.gz'
  sha1 '8a67268d995b8351bd5ee5acf1eebff910028e7e'
  head 'https://ceres-solver.googlesource.com/ceres-solver.git'

  option 'without-tests', 'Do not build and run the tests (not recommended).'

  depends_on 'cmake' => :build
  depends_on 'glog'
  depends_on 'gflags'
  depends_on 'eigen'
  depends_on 'suite-sparse' => :recommended

  def install
    cmake_args = std_cmake_args + ['-DBUILD_SHARED_LIBS=ON']
    system "cmake", ".", *cmake_args
    system "make"
    system "make test" if build.with? 'tests'
    system "make", "install"
  end
end

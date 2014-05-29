require 'formula'

class CeresSolver < Formula
  homepage 'http://ceres-solver.org/'
  url 'http://ceres-solver.org/ceres-solver-1.9.0.tar.gz'
  sha1 'f73ab69cfa1e19d40961503984bc7d6b601cb8a6'
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

require 'formula'

class CeresSolver < Formula
  homepage 'http://ceres-solver.org/'
  url 'http://ceres-solver.org/ceres-solver-1.10.0.tar.gz'
  sha1 '340bf0676ed8b1da02a66ee4595923ba9fc75f1f'
  head 'https://ceres-solver.googlesource.com/ceres-solver.git'

  option 'without-tests', 'Do not build and run the tests (not recommended).'

  depends_on 'cmake' => :build
  depends_on 'glog'
  depends_on 'gflags'
  depends_on 'eigen'
  depends_on 'suite-sparse' => :recommended

  def suite_sparse_options
    Tab.for_formula(Formula["suite-sparse"])
  end

  def install
    cmake_args = std_cmake_args + ['-DBUILD_SHARED_LIBS=ON']
    cmake_args << "-DMETIS_LIBRARY=#{Formula["metis4"].opt_lib}/libmetis.dylib" if suite_sparse_options.with? "metis4"
    system "cmake", ".", *cmake_args
    system "make"
    system "make test" if build.with? 'tests'
    system "make", "install"
  end
end

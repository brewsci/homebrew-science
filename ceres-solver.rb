require 'formula'

class CeresSolver < Formula
  homepage 'http://ceres-solver.org/'
  url 'http://ceres-solver.org/ceres-solver-1.11.0.tar.gz'
  sha1 '5e8683bfb410b1ba8b8204eeb0ec1fba009fb2d0'
  head 'https://ceres-solver.googlesource.com/ceres-solver.git'

  bottle do
    sha1 "f63f940e4d950fde0c231e0ea431bd2a0834d1d8" => :yosemite
    sha1 "21afb7720c98d4961d66ca517f31ccbc9037fe2c" => :mavericks
    sha1 "04b4f8954e4dcc4284138cdaf5837cf4575a4c20" => :mountain_lion
  end

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
    cmake_args << "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
    system "cmake", ".", *cmake_args
    system "make"
    system "make test" if build.with? 'tests'
    system "make", "install"
  end
end

class CeresSolver < Formula
  desc "C++ library for modeling and solving large, complicated optimization problems."
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.11.0.tar.gz"
  sha256 "4d666cc33296b4c5cd77bad18ffc487b3223d4bbb7d1dfb342ed9a87dc9af844"
  head "https://ceres-solver.googlesource.com/ceres-solver.git"
  revision 1

  bottle do
    cellar :any
    sha256 "6f304a4431d100b7f0431ac6ac9716ab73975f761cc910c5373e4d6dfa79ad36" => :el_capitan
    sha256 "9af505a2bc76ba2a3ba8528edc3261c13a3e16b98c2f6b9aaf93884f98004eda" => :yosemite
    sha256 "8da9db5929b1d0883f249f6fcfaddf42cb858296cb0777203c9928d5dfacdfef" => :mavericks
  end

  option "without-tests", "Do not build and run the tests (not recommended)."

  depends_on "cmake" => :build
  depends_on "glog"
  depends_on "gflags"
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended

  def suite_sparse_options
    Tab.for_formula(Formula["suite-sparse"])
  end

  def install
    cmake_args = std_cmake_args + ["-DBUILD_SHARED_LIBS=ON"]
    cmake_args << "-DMETIS_LIBRARY=#{Formula["metis4"].opt_lib}/libmetis.dylib" if suite_sparse_options.with? "metis4"
    cmake_args << "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
    system "cmake", ".", *cmake_args
    system "make"
    system "make test" if build.with? "tests"
    system "make", "install"
  end
end

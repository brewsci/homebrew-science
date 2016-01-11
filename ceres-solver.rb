class CeresSolver < Formula
  desc "C++ library for modeling and solving large, complicated optimization problems."
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.11.0.tar.gz"
  sha256 "4d666cc33296b4c5cd77bad18ffc487b3223d4bbb7d1dfb342ed9a87dc9af844"
  head "https://ceres-solver.googlesource.com/ceres-solver.git"
  revision 1

  bottle do
    sha256 "f11c49891b9e084fc4d82aac72c85c04595435502e7f92014c3b5910e56211cd" => :el_capitan
    sha256 "6ceffb043d52314e66ec22ba947af3944b30c86c41b06ea4db17e640066723ab" => :yosemite
    sha256 "f0ff74807c03feabd7430ad886af57a1c8e1beb0d8f8e731adb442570d046a50" => :mavericks
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

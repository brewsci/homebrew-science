class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.11.0.tar.gz"
  sha256 "4d666cc33296b4c5cd77bad18ffc487b3223d4bbb7d1dfb342ed9a87dc9af844"
  revision 3

  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "4fe9ddd81522798852b916d25c24c0f066f52d21f20090057fb15b26ae6c6ca0" => :el_capitan
    sha256 "26c3ad20a2cadd0b133e8bb5709a5ffc3fc50d2386806d2e9d7ccc562e215ba1" => :yosemite
    sha256 "b0221e81a11ff93976ba27ad6373c5d8aab8f9ca991f540eb1a0dde90ebf24c4" => :mavericks
  end

  option "without-test", "Do not build and run the tests (not recommended)."
  deprecated_option "without-tests" => "without-test"

  depends_on "cmake" => :run
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
    system "make", "test" if build.with? "test"
    system "make", "install"
    pkgshare.install "examples"
    pkgshare.install "data"
    doc.install "docs/html"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<-EOS.undent
      cmake_minimum_required(VERSION 2.8)
      project(helloworld)
      find_package(Ceres REQUIRED)
      include_directories(${CERES_INCLUDE_DIRS})
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld ${CERES_LIBRARIES})
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld", 0)
  end
end

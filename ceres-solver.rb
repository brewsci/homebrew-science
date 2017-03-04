class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.12.0.tar.gz"
  sha256 "745bfed55111e086954126b748eb9efe20e30be5b825c6dec3c525cf20afc895"
  revision 4

  bottle do
    cellar :any
    sha256 "afaab0958994daf17c34ff9a730f5947889ff3930aa1e692bb2ce14def4d6f97" => :sierra
    sha256 "77ed7515db9ccd61c9c48818067b6d01c1e65ee1220e7031b5a4b2dc8ab9aa18" => :el_capitan
    sha256 "be1aaa3112a6c01be1c17e96b5e3fb440e5c65018c1bee6eabb7e7e809b3e6dd" => :yosemite
  end

  head do
    url "https://ceres-solver.googlesource.com/ceres-solver.git"

    depends_on "sphinx-doc" => :build
  end

  option "without-test", "Do not build and run the tests (not recommended)."
  deprecated_option "without-tests" => "without-test"

  depends_on "cmake" => :run
  depends_on "glog"
  depends_on "gflags"
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended
  if build.with? "suite-sparse"
    depends_on "metis"
  elsif OS.linux?
    depends_on "openblas" => :recommended
  end

  def install
    so = OS.mac? ? "dylib" : "so"
    cmake_args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
    ]
    if build.with? "suite-sparse"
      cmake_args << "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/libmetis.#{so}"
    else
      cmake_args << "-DSUITESPARSE=OFF"
    end
    cmake_args << "-DBUILD_DOCUMENTATION=ON" if build.head?
    system "cmake", ".", *cmake_args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
    pkgshare.install "examples", "data"
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
